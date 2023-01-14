// This file is a part of media_kit
// (https://github.com/alexmercerind/media_kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#include "video_output_manager.h"

VideoOutputManager::VideoOutputManager(
    flutter::PluginRegistrarWindows* registrar,
    flutter::MethodChannel<flutter::EncodableValue>* channel)
    : registrar_(registrar), channel_(channel) {}

VideoOutput* VideoOutputManager::Create(int64_t handle,
                                        std::optional<int64_t> width,
                                        std::optional<int64_t> height) {
  if (video_outputs_.find(handle) == video_outputs_.end()) {
    auto video_output =
        std::make_unique<VideoOutput>(handle, width, height, registrar_);
    video_output->SetTextureUpdateCallback(
        [=](int64_t id, int64_t width, int64_t height) -> void {
          channel_->InvokeMethod(
              "VideoOutput.Resize",
              std::make_unique<flutter::EncodableValue>(flutter::EncodableMap({
                  {
                      VALUE("handle"),
                      VALUE(handle),
                  },
                  {
                      VALUE("id"),
                      VALUE(id),
                  },
                  {
                      VALUE("rect"),
                      VALUE(flutter::EncodableMap({
                          {
                              VALUE("left"),
                              VALUE(0),
                          },
                          {
                              VALUE("top"),
                              VALUE(0),
                          },
                          {
                              VALUE("right"),
                              VALUE(width),
                          },
                          {
                              VALUE("bottom"),
                              VALUE(height),
                          },
                      })),
                  },

              })),
              nullptr);
        });
    video_outputs_.insert({handle, std::move(video_output)});
  }
  return video_outputs_[handle].get();
}

bool VideoOutputManager::Dispose(int64_t handle) {
  if (video_outputs_.find(handle) == video_outputs_.end()) {
    return false;
  }
  video_outputs_.erase(handle);
  return true;
}

VideoOutputManager::~VideoOutputManager() {
  // Destroy all video outputs.
  // |VideoOutput| destructor will do the relevant cleanup.
  video_outputs_.clear();
}
