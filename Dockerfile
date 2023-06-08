ARG FROM_SOURCE=squidfunk/mkdocs-material
FROM ${FROM_SOURCE}

RUN apk add --no-cache py3-pip py3-pillow py3-cffi py3-brotli gcc musl-dev python3-dev pango build-base libffi-dev jpeg-dev libxslt-dev pngquant py3-cairosvg

RUN pip install \
        beautifulsoup4==4.9.3 \
        mkdocs-autolinks-plugin \
        mkdocs-htmlproofer-plugin \
	mkdocs-git-revision-date-localized-plugin \
        mkdocs-macros-plugin \
        mkdocs-git-committers-plugin-2 \
        mkdocs-meta-descriptions-plugin \
        mkdocs-with-pdf \
        mkdocs-extra-sass-plugin \
        mkdocs-rss-plugin \
        qrcode \
        livereload

RUN   git config --global --add safe.directory /docs