// build protobuf-c-text library somewhat like this:
// CC=clang CXX=clang++ CFLAGS="-g -O2 -fsanitize=fuzzer-no-link,address -I${HOME}/fuzzing/build/include" CXXFLAGS="-g -O2 -fsanitize=fuzzer-no-link,address -I${HOME}/fuzzing/build/include" LDFLAGS="-L${HOME}/fuzzing/build/lib" ./configure --prefix=${HOME}/fuzzing/build
// make && make install
//
// then build this fuzz target binary like this:
// clang fuzz-test-full.c test-full.pb-c.c -I${HOME}/fuzzing/build/include -I${HOME}/fuzzing/protobuf-c -L${HOME}/fuzzing/build/lib -g -lprotobuf-c -fsanitize=fuzzer,address -o fuzz-test-full
//
// Execute with:
// LD_LIBRARY_PATH=${HOME}/fuzzing/build/lib ./fuzz-test-full

#include <stdio.h>
#include <stdlib.h>
#include "test-full.pb-c.h"

int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size) {
  Foo__TestMess *msg;

  // Unpack the message using protobuf-c.
  msg = foo__test_mess__unpack(NULL, Size, Data);
  if (msg == NULL)
  {
    //fprintf(stderr, "error unpacking incoming message\n");
    return 0;
  }

  // Free the unpacked message
  foo__test_mess__free_unpacked(msg, NULL);
  return 0;
}
