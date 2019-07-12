export LLVM_ROOT=c:/projects/clang-experimental
cd $LLVM_ROOT
echo "Cwd =" `pwd`
mkdir build
cd build
export CC=cl.exe
export CXX=cl.exe
cmake -G "CodeBlocks - Unix Makefiles"  -DCMAKE_BUILD_TYPE=Release c:/projects/clang-experimental/llvm -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DPYTHON_EXECUTABLE:FILEPATH=c:\\Python27\\python.exe

export PROJ_ROOT=c:/projects/clang-experimental/build
echo "Cwd =" `pwd`
make clang-format
echo `pwd`
cd $PROJ_ROOT
echo `pwd`
zip $PROJ_ROOT/clang-format-experimental.zip $PROJ_ROOT/bin/clang-format.exe
