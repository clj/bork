action=$1
name=$2
shift 2

case $action in
  desc)
    ;;

  status)
    baking_platform_is "Darwin" || return $STATUS_UNSUPPORTED_PLATFORM
    needs_exec "brew" || return $STATUS_FAILED_PRECONDITION
    $(bake brew cask) || return $STATUS_FAILED_PRECONDITION

    bake brew cask list | grep -E "^$name$" > /dev/null
    [ "$?" -gt 0 ] && return $STATUS_MISSING
    return 0 ;;

  install) bake brew cask install $name ;;

  *) return 1 ;;
esac
