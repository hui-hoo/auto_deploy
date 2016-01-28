
function error_log() {
    msg=$1
    if [ -z "$msg" ];then
        echo "ERROR: Usage: ${FUNCNAME[0]}  error_message"
    else
        echo "ERROR: $msg" 
    fi 
}

function debug_log() {
    msg=$1
    if [ -z "$msg" ];then
        error_log "Usage: ${FUNCNAME[0]} debug_message"
    else
        echo "DEBUG: $msg" 
    fi 
}

function remove_dirs() {
    if [ "$#" -lt 1 ];then
        error_log "Usage: ${FUNCNAME[0]} dirname ..."
    else
        for dir in "$@"
        do
            [ -e "$dir" ] && rm -rf "$dir"
        done
    fi
}
