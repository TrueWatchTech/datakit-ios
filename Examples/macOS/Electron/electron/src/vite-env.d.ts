/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_FT_APPLICATION_ID?: string
  readonly VITE_FT_DATAKIT_ORIGIN?: string
  readonly VITE_FT_SERVICE?: string
  readonly VITE_FT_ENV?: string
  readonly VITE_FT_SESSION_REPLAY?: string
  readonly VITE_FT_ALLOWED_TRACING_URL?: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}

interface NativeSettingsSummary {
  applicationId: string
  intakeMode: 'DataKit' | 'DataWay'
  service: string
  environment: string
  sampleRate: number
  loggingEnabled: boolean
  replayEnabled: boolean
  traceEnabled: boolean
}

interface AppInfo {
  name: string
  version: string
  electronVersion: string
  chromeVersion: string
  platform: string
  arch: string
  adapterMode: 'managed'
  capabilities?: Record<string, unknown>
  nativeSettings?: NativeSettingsSummary
}

interface Window {
  FTWebViewJavascriptBridge?: {
    sendEvent(serializedEvent: string): void
  }
  orbitDesk: {
    getAppInfo: () => Promise<AppInfo>
    openAuxiliaryWindow: () => Promise<{ webContentsID: number }>
    rendererReady: (status: 'active' | 'error') => void
  }
}
