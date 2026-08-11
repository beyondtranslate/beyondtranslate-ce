# The Flutter tooling requires an FFI plugin to provide a platform CMake file.
# The Rust library itself is built and bundled by hook/build.dart through
# Flutter native assets, so there is no additional CMake target to build here.
cmake_minimum_required(VERSION 3.14)

project(beyondtranslate_runtime LANGUAGES CXX)

# Keep this variable defined because generated_plugins.cmake appends it to the
# application's bundled libraries. The native-assets hook supplies the DLL.
set(beyondtranslate_runtime_bundled_libraries
  ""
  PARENT_SCOPE
)
