import { truewatchRum } from '@truewatchtech/browser-rum'
import { truewatchLogs } from '@truewatchtech/browser-logs'

type RumConfiguration = Parameters<typeof truewatchRum.init>[0]
export type WebLogLevel = 'debug' | 'info' | 'warn' | 'error'

export interface RumRuntimeState {
  configured: boolean
  status: 'active' | 'not-configured' | 'error'
  message: string
  intakeMode: 'Native SDK Bridge'
  service: string
  environment: string
  applicationId: string
  sessionReplay: boolean
  webLogs: boolean
}

const service = import.meta.env.VITE_FT_SERVICE || 'orbitdesk-electron'
const environment = import.meta.env.VITE_FT_ENV || (import.meta.env.DEV ? 'development' : 'production')
const bridgeOnlyConfiguration = {
  applicationId: import.meta.env.VITE_FT_APPLICATION_ID?.trim() || 'native-bridge',
  datakitOrigin: import.meta.env.VITE_FT_DATAKIT_ORIGIN?.trim() || 'http://127.0.0.1:9529',
} as const

let rumActive = false

let runtimeState: RumRuntimeState = {
  configured: false,
  status: 'not-configured',
  message: 'Waiting for the Native SDK bridge',
  intakeMode: 'Native SDK Bridge',
  service,
  environment,
  applicationId: 'Owned by Native SDK',
  sessionReplay: false,
  webLogs: false,
}

function getDeviceId(): string {
  const storageKey = 'orbitdesk.rum-device-id'
  const stored = window.localStorage.getItem(storageKey)
  if (stored) return stored

  const id = `desktop-${crypto.randomUUID()}`
  window.localStorage.setItem(storageKey, id)
  return id
}

export function initializeRum(appInfo: AppInfo): RumRuntimeState {
  const tracingUrl = import.meta.env.VITE_FT_ALLOWED_TRACING_URL?.trim() || ''
  const sessionReplay = appInfo.capabilities?.replay === true &&
    import.meta.env.VITE_FT_SESSION_REPLAY !== 'false'
  const webLogs = appInfo.capabilities?.log === true

  if (typeof window.FTWebViewJavascriptBridge?.sendEvent !== 'function') {
    runtimeState = {
      ...runtimeState,
      status: 'error',
      message: 'The Native SDK bridge is unavailable',
      sessionReplay,
      webLogs: false,
    }
    return runtimeState
  }

  try {
    truewatchRum.init({
      ...bridgeOnlyConfiguration,
      service,
      env: environment,
      version: appInfo.version,
      sessionSampleRate: 100,
      sessionReplaySampleRate: sessionReplay ? 100 : 0,
      trackUserInteractions: true,
      trackViewsManually: true,
      actionNameAttribute: 'data-truewatch-action-name',
      sessionPersistence: 'local-storage',
      ...(tracingUrl
        ? {
            allowedTracingUrls: [tracingUrl],
            traceType: 'ddtrace' as RumConfiguration['traceType'],
          }
        : {}),
      beforeSend: (event) => {
        if (import.meta.env.DEV) {
          console.debug('[TrueWatch RUM]', event.type)
        }
        return true
      },
    })

    if (import.meta.env.DEV) {
      // local-storage intentionally persists sessions across restarts. A fresh
      // session per dev launch makes RUM and Replay debugging deterministic.
      truewatchRum.stopSession()
      truewatchRum.startSession({ sessionSampleRate: 100 })
      window.setTimeout(() => {
        console.debug(
          `[TrueWatch RUM] development_session ${truewatchRum.getInternalContext()?.session.id ?? 'unknown'}`,
        )
      }, 250)
    }

    const user = { id: getDeviceId() }
    const globalContext = {
      desktop_platform: appInfo.platform,
      desktop_arch: appInfo.arch,
      electron_version: appInfo.electronVersion,
    }
    truewatchRum.setUser(user)
    truewatchRum.setGlobalContext(globalContext)

    if (webLogs) {
      truewatchLogs.init({
        datakitOrigin: bridgeOnlyConfiguration.datakitOrigin,
        service,
        env: environment,
        version: appInfo.version,
        sessionSampleRate: 100,
        sessionPersistence: 'local-storage',
        forwardErrorsToLogs: true,
        beforeSend: (event) => {
          if (import.meta.env.DEV) {
            console.debug('[TrueWatch Web Logs]', event.status, event.message)
          }
          return true
        },
      })
      truewatchLogs.setUser(user)
      truewatchLogs.setGlobalContext(globalContext)
    }

    if (sessionReplay) {
      // Force upgrades a session that may have been persisted before Replay was
      // enabled. This is important for Electron file:// pages using localStorage.
      truewatchRum.startSessionReplayRecording({ force: true })

      if (import.meta.env.DEV) {
        for (const delay of [1000, 3000, 5000]) {
          window.setTimeout(() => {
            const recording = truewatchRum.isRecording()
            console.debug(
              `[TrueWatch RUM] session_replay ${delay}ms`,
              recording ? 'recording' : 'not_recording',
            )
          }, delay)
        }
      }
    }

    truewatchRum.startView({ name: 'Dashboard' })
    rumActive = true
    runtimeState = {
      configured: true,
      status: 'active',
      message: webLogs
        ? 'Web RUM and Browser Logs are collecting through the Native SDK bridge'
        : 'Web RUM is collecting; Native Browser Logs are disabled',
      intakeMode: 'Native SDK Bridge',
      service,
      environment,
      applicationId: 'Owned by Native SDK',
      sessionReplay,
      webLogs,
    }
    sendLog('OrbitDesk Renderer initialized', {
      source: 'renderer_startup',
      surface: 'dashboard',
    })
  } catch (error) {
    console.error('TrueWatch RUM initialization failed', error)
    runtimeState = {
      configured: false,
      status: 'error',
      message: error instanceof Error ? error.message : 'SDK initialization failed',
      intakeMode: 'Native SDK Bridge',
      service,
      environment,
      applicationId: 'Owned by Native SDK',
      sessionReplay,
      webLogs: false,
    }
  }

  return runtimeState
}

export function getRumRuntimeState(): RumRuntimeState {
  return runtimeState
}

export function isSessionReplayRecording(): boolean {
  return rumActive && truewatchRum.isRecording()
}

export function startRumView(name: string): void {
  if (rumActive) {
    truewatchRum.startView({ name })
  }
}

export function trackAction(name: string, context?: Record<string, unknown>): void {
  if (rumActive) {
    truewatchRum.addAction(name, context)
  }
}

export function reportError(error: Error, context?: Record<string, unknown>): void {
  if (rumActive) {
    truewatchRum.addError(error, context)
  }
}

export function sendLog(
  message: string,
  context?: Record<string, unknown>,
  level: WebLogLevel = 'info',
  error?: Error,
): boolean {
  if (!runtimeState.webLogs) return false
  if (level === 'debug') truewatchLogs.logger.debug(message, context, error)
  else if (level === 'warn') truewatchLogs.logger.warn(message, context, error)
  else if (level === 'error') truewatchLogs.logger.error(message, context, error)
  else truewatchLogs.logger.info(message, context, error)
  return true
}
