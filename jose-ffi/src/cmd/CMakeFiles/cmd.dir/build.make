# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.27

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/anon/workspace/tanga/jose-ffi/src

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/anon/workspace/tanga/jose-ffi/src

# Include any dependencies generated for this target.
include cmd/CMakeFiles/cmd.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include cmd/CMakeFiles/cmd.dir/compiler_depend.make

# Include the progress variables for this target.
include cmd/CMakeFiles/cmd.dir/progress.make

# Include the compile flags for this target's objects.
include cmd/CMakeFiles/cmd.dir/flags.make

cmd/CMakeFiles/cmd.dir/jose.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jose.c.o: cmd/jose.c
cmd/CMakeFiles/cmd.dir/jose.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object cmd/CMakeFiles/cmd.dir/jose.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jose.c.o -MF CMakeFiles/cmd.dir/jose.c.o.d -o CMakeFiles/cmd.dir/jose.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jose.c

cmd/CMakeFiles/cmd.dir/jose.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jose.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jose.c > CMakeFiles/cmd.dir/jose.c.i

cmd/CMakeFiles/cmd.dir/jose.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jose.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jose.c -o CMakeFiles/cmd.dir/jose.c.s

cmd/CMakeFiles/cmd.dir/b64/dec.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/b64/dec.c.o: cmd/b64/dec.c
cmd/CMakeFiles/cmd.dir/b64/dec.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object cmd/CMakeFiles/cmd.dir/b64/dec.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/b64/dec.c.o -MF CMakeFiles/cmd.dir/b64/dec.c.o.d -o CMakeFiles/cmd.dir/b64/dec.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/dec.c

cmd/CMakeFiles/cmd.dir/b64/dec.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/b64/dec.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/dec.c > CMakeFiles/cmd.dir/b64/dec.c.i

cmd/CMakeFiles/cmd.dir/b64/dec.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/b64/dec.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/dec.c -o CMakeFiles/cmd.dir/b64/dec.c.s

cmd/CMakeFiles/cmd.dir/b64/enc.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/b64/enc.c.o: cmd/b64/enc.c
cmd/CMakeFiles/cmd.dir/b64/enc.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object cmd/CMakeFiles/cmd.dir/b64/enc.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/b64/enc.c.o -MF CMakeFiles/cmd.dir/b64/enc.c.o.d -o CMakeFiles/cmd.dir/b64/enc.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/enc.c

cmd/CMakeFiles/cmd.dir/b64/enc.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/b64/enc.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/enc.c > CMakeFiles/cmd.dir/b64/enc.c.i

cmd/CMakeFiles/cmd.dir/b64/enc.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/b64/enc.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/b64/enc.c -o CMakeFiles/cmd.dir/b64/enc.c.s

cmd/CMakeFiles/cmd.dir/jwk/eql.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/eql.c.o: cmd/jwk/eql.c
cmd/CMakeFiles/cmd.dir/jwk/eql.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object cmd/CMakeFiles/cmd.dir/jwk/eql.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/eql.c.o -MF CMakeFiles/cmd.dir/jwk/eql.c.o.d -o CMakeFiles/cmd.dir/jwk/eql.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/eql.c

cmd/CMakeFiles/cmd.dir/jwk/eql.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/eql.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/eql.c > CMakeFiles/cmd.dir/jwk/eql.c.i

cmd/CMakeFiles/cmd.dir/jwk/eql.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/eql.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/eql.c -o CMakeFiles/cmd.dir/jwk/eql.c.s

cmd/CMakeFiles/cmd.dir/jwk/exc.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/exc.c.o: cmd/jwk/exc.c
cmd/CMakeFiles/cmd.dir/jwk/exc.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building C object cmd/CMakeFiles/cmd.dir/jwk/exc.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/exc.c.o -MF CMakeFiles/cmd.dir/jwk/exc.c.o.d -o CMakeFiles/cmd.dir/jwk/exc.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/exc.c

cmd/CMakeFiles/cmd.dir/jwk/exc.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/exc.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/exc.c > CMakeFiles/cmd.dir/jwk/exc.c.i

cmd/CMakeFiles/cmd.dir/jwk/exc.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/exc.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/exc.c -o CMakeFiles/cmd.dir/jwk/exc.c.s

cmd/CMakeFiles/cmd.dir/jwk/gen.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/gen.c.o: cmd/jwk/gen.c
cmd/CMakeFiles/cmd.dir/jwk/gen.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building C object cmd/CMakeFiles/cmd.dir/jwk/gen.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/gen.c.o -MF CMakeFiles/cmd.dir/jwk/gen.c.o.d -o CMakeFiles/cmd.dir/jwk/gen.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/gen.c

cmd/CMakeFiles/cmd.dir/jwk/gen.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/gen.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/gen.c > CMakeFiles/cmd.dir/jwk/gen.c.i

cmd/CMakeFiles/cmd.dir/jwk/gen.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/gen.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/gen.c -o CMakeFiles/cmd.dir/jwk/gen.c.s

cmd/CMakeFiles/cmd.dir/jwk/pub.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/pub.c.o: cmd/jwk/pub.c
cmd/CMakeFiles/cmd.dir/jwk/pub.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building C object cmd/CMakeFiles/cmd.dir/jwk/pub.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/pub.c.o -MF CMakeFiles/cmd.dir/jwk/pub.c.o.d -o CMakeFiles/cmd.dir/jwk/pub.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/pub.c

cmd/CMakeFiles/cmd.dir/jwk/pub.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/pub.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/pub.c > CMakeFiles/cmd.dir/jwk/pub.c.i

cmd/CMakeFiles/cmd.dir/jwk/pub.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/pub.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/pub.c -o CMakeFiles/cmd.dir/jwk/pub.c.s

cmd/CMakeFiles/cmd.dir/jwk/thp.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/thp.c.o: cmd/jwk/thp.c
cmd/CMakeFiles/cmd.dir/jwk/thp.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building C object cmd/CMakeFiles/cmd.dir/jwk/thp.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/thp.c.o -MF CMakeFiles/cmd.dir/jwk/thp.c.o.d -o CMakeFiles/cmd.dir/jwk/thp.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/thp.c

cmd/CMakeFiles/cmd.dir/jwk/thp.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/thp.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/thp.c > CMakeFiles/cmd.dir/jwk/thp.c.i

cmd/CMakeFiles/cmd.dir/jwk/thp.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/thp.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/thp.c -o CMakeFiles/cmd.dir/jwk/thp.c.s

cmd/CMakeFiles/cmd.dir/jwk/use.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwk/use.c.o: cmd/jwk/use.c
cmd/CMakeFiles/cmd.dir/jwk/use.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building C object cmd/CMakeFiles/cmd.dir/jwk/use.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwk/use.c.o -MF CMakeFiles/cmd.dir/jwk/use.c.o.d -o CMakeFiles/cmd.dir/jwk/use.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/use.c

cmd/CMakeFiles/cmd.dir/jwk/use.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwk/use.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/use.c > CMakeFiles/cmd.dir/jwk/use.c.i

cmd/CMakeFiles/cmd.dir/jwk/use.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwk/use.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwk/use.c -o CMakeFiles/cmd.dir/jwk/use.c.s

cmd/CMakeFiles/cmd.dir/jws/fmt.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jws/fmt.c.o: cmd/jws/fmt.c
cmd/CMakeFiles/cmd.dir/jws/fmt.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building C object cmd/CMakeFiles/cmd.dir/jws/fmt.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jws/fmt.c.o -MF CMakeFiles/cmd.dir/jws/fmt.c.o.d -o CMakeFiles/cmd.dir/jws/fmt.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/fmt.c

cmd/CMakeFiles/cmd.dir/jws/fmt.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jws/fmt.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/fmt.c > CMakeFiles/cmd.dir/jws/fmt.c.i

cmd/CMakeFiles/cmd.dir/jws/fmt.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jws/fmt.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/fmt.c -o CMakeFiles/cmd.dir/jws/fmt.c.s

cmd/CMakeFiles/cmd.dir/jws/sig.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jws/sig.c.o: cmd/jws/sig.c
cmd/CMakeFiles/cmd.dir/jws/sig.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building C object cmd/CMakeFiles/cmd.dir/jws/sig.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jws/sig.c.o -MF CMakeFiles/cmd.dir/jws/sig.c.o.d -o CMakeFiles/cmd.dir/jws/sig.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/sig.c

cmd/CMakeFiles/cmd.dir/jws/sig.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jws/sig.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/sig.c > CMakeFiles/cmd.dir/jws/sig.c.i

cmd/CMakeFiles/cmd.dir/jws/sig.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jws/sig.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/sig.c -o CMakeFiles/cmd.dir/jws/sig.c.s

cmd/CMakeFiles/cmd.dir/jws/ver.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jws/ver.c.o: cmd/jws/ver.c
cmd/CMakeFiles/cmd.dir/jws/ver.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building C object cmd/CMakeFiles/cmd.dir/jws/ver.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jws/ver.c.o -MF CMakeFiles/cmd.dir/jws/ver.c.o.d -o CMakeFiles/cmd.dir/jws/ver.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/ver.c

cmd/CMakeFiles/cmd.dir/jws/ver.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jws/ver.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/ver.c > CMakeFiles/cmd.dir/jws/ver.c.i

cmd/CMakeFiles/cmd.dir/jws/ver.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jws/ver.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jws/ver.c -o CMakeFiles/cmd.dir/jws/ver.c.s

cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o: cmd/jwe/fmt.c
cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building C object cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o -MF CMakeFiles/cmd.dir/jwe/fmt.c.o.d -o CMakeFiles/cmd.dir/jwe/fmt.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/fmt.c

cmd/CMakeFiles/cmd.dir/jwe/fmt.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwe/fmt.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/fmt.c > CMakeFiles/cmd.dir/jwe/fmt.c.i

cmd/CMakeFiles/cmd.dir/jwe/fmt.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwe/fmt.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/fmt.c -o CMakeFiles/cmd.dir/jwe/fmt.c.s

cmd/CMakeFiles/cmd.dir/jwe/dec.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwe/dec.c.o: cmd/jwe/dec.c
cmd/CMakeFiles/cmd.dir/jwe/dec.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Building C object cmd/CMakeFiles/cmd.dir/jwe/dec.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwe/dec.c.o -MF CMakeFiles/cmd.dir/jwe/dec.c.o.d -o CMakeFiles/cmd.dir/jwe/dec.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/dec.c

cmd/CMakeFiles/cmd.dir/jwe/dec.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwe/dec.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/dec.c > CMakeFiles/cmd.dir/jwe/dec.c.i

cmd/CMakeFiles/cmd.dir/jwe/dec.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwe/dec.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/dec.c -o CMakeFiles/cmd.dir/jwe/dec.c.s

cmd/CMakeFiles/cmd.dir/jwe/enc.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/jwe/enc.c.o: cmd/jwe/enc.c
cmd/CMakeFiles/cmd.dir/jwe/enc.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_15) "Building C object cmd/CMakeFiles/cmd.dir/jwe/enc.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/jwe/enc.c.o -MF CMakeFiles/cmd.dir/jwe/enc.c.o.d -o CMakeFiles/cmd.dir/jwe/enc.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/enc.c

cmd/CMakeFiles/cmd.dir/jwe/enc.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/jwe/enc.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/enc.c > CMakeFiles/cmd.dir/jwe/enc.c.i

cmd/CMakeFiles/cmd.dir/jwe/enc.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/jwe/enc.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/jwe/enc.c -o CMakeFiles/cmd.dir/jwe/enc.c.s

cmd/CMakeFiles/cmd.dir/alg.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/alg.c.o: cmd/alg.c
cmd/CMakeFiles/cmd.dir/alg.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_16) "Building C object cmd/CMakeFiles/cmd.dir/alg.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/alg.c.o -MF CMakeFiles/cmd.dir/alg.c.o.d -o CMakeFiles/cmd.dir/alg.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/alg.c

cmd/CMakeFiles/cmd.dir/alg.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/alg.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/alg.c > CMakeFiles/cmd.dir/alg.c.i

cmd/CMakeFiles/cmd.dir/alg.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/alg.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/alg.c -o CMakeFiles/cmd.dir/alg.c.s

cmd/CMakeFiles/cmd.dir/fmt.c.o: cmd/CMakeFiles/cmd.dir/flags.make
cmd/CMakeFiles/cmd.dir/fmt.c.o: cmd/fmt.c
cmd/CMakeFiles/cmd.dir/fmt.c.o: cmd/CMakeFiles/cmd.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_17) "Building C object cmd/CMakeFiles/cmd.dir/fmt.c.o"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT cmd/CMakeFiles/cmd.dir/fmt.c.o -MF CMakeFiles/cmd.dir/fmt.c.o.d -o CMakeFiles/cmd.dir/fmt.c.o -c /home/anon/workspace/tanga/jose-ffi/src/cmd/fmt.c

cmd/CMakeFiles/cmd.dir/fmt.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/cmd.dir/fmt.c.i"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/anon/workspace/tanga/jose-ffi/src/cmd/fmt.c > CMakeFiles/cmd.dir/fmt.c.i

cmd/CMakeFiles/cmd.dir/fmt.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/cmd.dir/fmt.c.s"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && /usr/lib64/ccache/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/anon/workspace/tanga/jose-ffi/src/cmd/fmt.c -o CMakeFiles/cmd.dir/fmt.c.s

# Object files for target cmd
cmd_OBJECTS = \
"CMakeFiles/cmd.dir/jose.c.o" \
"CMakeFiles/cmd.dir/b64/dec.c.o" \
"CMakeFiles/cmd.dir/b64/enc.c.o" \
"CMakeFiles/cmd.dir/jwk/eql.c.o" \
"CMakeFiles/cmd.dir/jwk/exc.c.o" \
"CMakeFiles/cmd.dir/jwk/gen.c.o" \
"CMakeFiles/cmd.dir/jwk/pub.c.o" \
"CMakeFiles/cmd.dir/jwk/thp.c.o" \
"CMakeFiles/cmd.dir/jwk/use.c.o" \
"CMakeFiles/cmd.dir/jws/fmt.c.o" \
"CMakeFiles/cmd.dir/jws/sig.c.o" \
"CMakeFiles/cmd.dir/jws/ver.c.o" \
"CMakeFiles/cmd.dir/jwe/fmt.c.o" \
"CMakeFiles/cmd.dir/jwe/dec.c.o" \
"CMakeFiles/cmd.dir/jwe/enc.c.o" \
"CMakeFiles/cmd.dir/alg.c.o" \
"CMakeFiles/cmd.dir/fmt.c.o"

# External object files for target cmd
cmd_EXTERNAL_OBJECTS =

cmd/cmd: cmd/CMakeFiles/cmd.dir/jose.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/b64/dec.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/b64/enc.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/eql.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/exc.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/gen.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/pub.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/thp.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwk/use.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jws/fmt.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jws/sig.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jws/ver.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwe/fmt.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwe/dec.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/jwe/enc.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/alg.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/fmt.c.o
cmd/cmd: cmd/CMakeFiles/cmd.dir/build.make
cmd/cmd: lib/libjose_ffi.so
cmd/cmd: cmd/CMakeFiles/cmd.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/anon/workspace/tanga/jose-ffi/src/CMakeFiles --progress-num=$(CMAKE_PROGRESS_18) "Linking C executable cmd"
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/cmd.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
cmd/CMakeFiles/cmd.dir/build: cmd/cmd
.PHONY : cmd/CMakeFiles/cmd.dir/build

cmd/CMakeFiles/cmd.dir/clean:
	cd /home/anon/workspace/tanga/jose-ffi/src/cmd && $(CMAKE_COMMAND) -P CMakeFiles/cmd.dir/cmake_clean.cmake
.PHONY : cmd/CMakeFiles/cmd.dir/clean

cmd/CMakeFiles/cmd.dir/depend:
	cd /home/anon/workspace/tanga/jose-ffi/src && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/anon/workspace/tanga/jose-ffi/src /home/anon/workspace/tanga/jose-ffi/src/cmd /home/anon/workspace/tanga/jose-ffi/src /home/anon/workspace/tanga/jose-ffi/src/cmd /home/anon/workspace/tanga/jose-ffi/src/cmd/CMakeFiles/cmd.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : cmd/CMakeFiles/cmd.dir/depend
