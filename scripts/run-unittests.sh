#!/bin/bash

set -ex

test-hostname-verification() {
    test/tlscommunicationtest.py test test pass
    test/tlscommunicationtest.py test '*' pass
    test/tlscommunicationtest.py test 'te*' pass
    test/tlscommunicationtest.py testsite 'te*site' pass
    test/tlscommunicationtest.py testsite 't*s*e' fail
    test/tlscommunicationtest.py test.sub test.sub pass
    test/tlscommunicationtest.py test.sub '*.sub' pass
    test/tlscommunicationtest.py test.sub '*' fail
    test/tlscommunicationtest.py test.sub '*.*' pass
    test/tlscommunicationtest.py test.sub invalid.sub fail
    test/tlscommunicationtest.py test.sub 'invalid.*' fail
    test/tlscommunicationtest.py TEST.SUB test.sub pass
    test/tlscommunicationtest.py test '*ss' fail
    test/tlscommunicationtest.py test 'tt*' fail
    test/tlscommunicationtest.py test 'test*' pass
    test/tlscommunicationtest.py test '*test' pass
    test/tlscommunicationtest.py test '*te' fail
    test/tlscommunicationtest.py test 'te*st' pass
    test/tlscommunicationtest.py test tes fail
    test/tlscommunicationtest.py test testa fail
    test/tlscommunicationtest.py teest 'tee*est' fail
}

test-server() {
    test/tlscommunicationtest.py --use-openssl-client test.foo '*.foo' pass
}

test-fstrace() {
    local arch=$1
    stage/$arch/build/test/fstracecheck
}

realpath () {
    # reimplementation of "readlink -fw" for OSX
    python -c "import os.path, sys; print os.path.realpath(sys.argv[1])" "$1"
}

main() {
    cd "$(dirname "$(realpath "$0")")/.."
    case "$(uname)" in
        Linux)
            test-fstrace linux64
            test-hostname-verification
            test-server
            ;;
        Darwin)
            test-fstrace darwin
            test-server
            ;;
        *)
            echo "$0: Unknown OS architecture: $os" >&2
            exit 1
    esac
}

main "$@"
