//
//  TrueWatchElectronBridge.h
//  TrueWatchElectronBridge
//
//  Electron component C ABI.
//
//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#ifndef TrueWatchElectronBridge_h
#define TrueWatchElectronBridge_h

#include <TargetConditionals.h>
#include <stdint.h>

#if TARGET_OS_OSX

#if defined(__GNUC__)
#define FT_ELECTRON_EXPORT __attribute__((visibility("default")))
#else
#define FT_ELECTRON_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

FT_ELECTRON_EXPORT char *ft_electron_invoke(
    const char *method,
    const char *payload_json
);
FT_ELECTRON_EXPORT void ft_electron_free_string(char *value);

FT_ELECTRON_EXPORT int32_t ft_electron_bridge_configuration(
    char *output,
    int32_t capacity
);
FT_ELECTRON_EXPORT int32_t ft_electron_register_web_contents(
    void *electron_view,
    int64_t web_contents_id,
    int64_t slot_id,
    int32_t visible,
    int32_t z_index,
    int32_t has_bounds,
    double x,
    double y,
    double width,
    double height
);
FT_ELECTRON_EXPORT int32_t ft_electron_update_web_contents(
    void *electron_view,
    int64_t web_contents_id,
    int32_t visible,
    int32_t z_index,
    int32_t has_bounds,
    double x,
    double y,
    double width,
    double height
);
FT_ELECTRON_EXPORT int32_t ft_electron_receive_web_contents_message(
    int64_t web_contents_id,
    const char *message_queue
);
FT_ELECTRON_EXPORT void ft_electron_unregister_web_contents(
    int64_t web_contents_id
);

typedef void (*ft_electron_command_callback)(
    int64_t web_contents_id,
    const char *command,
    void *context
);
FT_ELECTRON_EXPORT void ft_electron_set_command_handler(
    ft_electron_command_callback callback,
    void *context
);

#ifdef __cplusplus
}
#endif

#undef FT_ELECTRON_EXPORT

#endif // TARGET_OS_OSX

#endif
