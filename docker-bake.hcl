variable "VERSION" {
    default = ""
}

// Sometimes tag cannot be verified, so we need to skip it
variable "SKIP_VERIFY_TAG" {
    default = ""
}

variable "COMMIT" {
    default = ""
}

variable "CONTEXT" {
    default = "global"
    // The context to use when building the image.
    // 'global' will build from the root of the repository
    // 'local' will build from the image directory
}

variable "IMAGE_PATH" {
    default = "docker/${NAME}"
}

variable "DOCKERFILE" {
    default = "Dockerfile"
}

function "shorten" {
    params = [ string ]
    result = substr(string, 0, 7)
}

function "tag" {
    params = [ name, tag ]
    result = notequal("",tag) ? [ "ghcr.io/ln-markets/${name}:${tag}", "lnmarkets/${name}:${tag}" ] : []
}

function "path_from_context" {
    params = [ path ]
    result = CONTEXT == "global" ? "${IMAGE_PATH}/${path}" : path
}

target "default" {
    context = CONTEXT == "global" ? "." : "${IMAGE_PATH}"
    dockerfile = path_from_context(DOCKERFILE)
    labels = {
        "org.opencontainers.image.title" = "${NAME}"
        "org.opencontainers.image.description" = "${DESCRIPTION}"
        "org.opencontainers.image.source" = "https://github.com/ln-markets/images"
        "org.opencontainers.image.url" = "https://github.com/ln-markets/images/tree/master/${IMAGE_PATH}"
    }
    args = {
        "VERSION" = "${VERSION}"
        "COMMIT" = "${COMMIT}"
        "SKIP_VERIFY_TAG" = "${SKIP_VERIFY_TAG}"
    }
}

target "all-platforms" {
    inherits = [ "default" ]
    platforms = [ "linux/amd64", "linux/arm64" ]
}

target "local" {
    inherits = ["default"]
    tags = [ "${NAME}:${VERSION}" ]
}

target "release" {
    inherits = ["all-platforms"]
    tags = concat(tag(NAME, "latest"), tag(NAME, VERSION))
    labels = {
        "org.opencontainers.image.version" = "${VERSION}"
        // "org.opencontainers.image.revision" = "${COMMIT}"
    }
}

target "nightly" {
    inherits = ["all-platforms"]
    tags = concat(tag(NAME, "nightly"), tag(NAME, shorten(COMMIT)))
    labels = {
        "org.opencontainers.image.revision" = "${COMMIT}"
    }
}
