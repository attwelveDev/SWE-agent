_debug_command() {
    echo "<<INTERACTIVE||$@||INTERACTIVE>>"
}

# @yaml
# signature: debug_start <mainClass> [<args>]
# docstring: Starts a debug session with the given Java main class.
# arguments:
#   mainClass:
#     type: string
#     description: the Java class with a main method to debug.
#     required: true
#   args:
#     type: string
#     description: optional command-line arguments for the Java program.
#     required: false
debug_start() {
    if [ -z "$1" ]
    then
        echo "Usage: debug_start <mainClass> [<args>]"
        return
    fi
    mainClass=$1
    shift
    _debug_command "SESSION=jdb"
    _debug_command "START"
    _debug_command "run $mainClass $@"
    export INTERACTIVE_SESSION="jdb $mainClass $@"
}

# @yaml
# signature: debug_stop_at <class:line>
# docstring: Adds a breakpoint in the debug session at a class+line.
# arguments:
#   breakpoint:
#     type: string
#     description: The breakpoint location (e.g. MyClass:42).
#     required: true
debug_stop_at() {
    if [ -z "$1" ]
    then
        echo "Usage: debug_stop_at <class:line>"
        return
    fi
    _debug_command "SESSION=jdb"
    _debug_command "stop at $1"
}

# @yaml
# signature: debug_stop_in <class.method>
# docstring: Adds a breakpoint in the debug session at a method in a class.
# arguments:
#   breakpoint:
#     type: string
#     description: The breakpoint location (e.g. MyClass.myMethod).
#     required: true
debug_stop_in() {
    if [ -z "$1" ]
    then
        echo "Usage: debug_stop_in <class.method>"
        return
    fi
    _debug_command "SESSION=jdb"
    _debug_command "stop in $1"
}

# @yaml
# signature: debug_cont
# docstring: Continues the program execution in the debug session.
debug_cont() {
    _debug_command "SESSION=jdb"
    _debug_command 'cont'
}

# @yaml
# signature: debug_step
# docstring: Steps one line in the debug session, including stepping into method calls.
debug_step() {
    _debug_command "SESSION=jdb"
    _debug_command 'step'
}

# @yaml
# signature: debug_next
# docstring: Steps one line in the debug session, including executing any method calls.
debug_next() {
    _debug_command "SESSION=jdb"
    _debug_command 'next'
}

# @yaml
# signature: debug_exec <command>
# docstring: Executes arbitrary jdb command in debug session.
# arguments:
#   command:
#     type: string
#     description: command to execute (wrap in single quotes to avoid shell escaping and substitution)
#     required: true
debug_exec() {
    if [ -z "$1" ]
    then
        echo "Usage: debug_exec <command>"
        return
    fi
    _debug_command "SESSION=jdb"
    _debug_command "$1"
}

# @yaml
# signature: debug_exit
# docstring: Exits the current debug session.
debug_exit() {
    _debug_command "SESSION=jdb"
    _debug_command "exit"
    _debug_command "STOP"
    unset INTERACTIVE_SESSION
}
