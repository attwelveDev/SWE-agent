# @yaml
# signature: decompile_java <class_file_path>
# docstring: decompiles a .class file into a .java file. The decompiled .java file is output into the directory `decompile_output`. Note that the .java file will be saved directly, i.e. if the .class file had parent directories, these parent directories are NOT saved in `decompile_output`.
# arguments:
#   class_file_path:
#     type: string
#     description: the path of the .class file to decompile.
#     required: true
decompile_java() {
    if [ -z "$1" ]
    then
        echo "Usage: decompile_java <class_file_path>"
        return
    fi

    java -jar jd-cli.jar "$1" -od decompile_output
}
