# docker pull squidfunk/mkdocs-material:latest
# docker build -t git.st1t.ru/thest1tch/mkdocs-material:latest -t git.st1t.ru/thest1tch/mkdocs-material:latest .
# docker push git.st1t.ru/thest1tch/mkdocs-material:latest

FROM squidfunk/mkdocs-material:latest

RUN apk add --no-cache py3-pip py3-pillow py3-cffi py3-brotli gcc musl-dev python3-dev pango build-base libffi-dev jpeg-dev libxslt-dev pngquant py3-cairosvg

RUN pip install \
		mkdocs-material \
		mkdocs-material-extensions>=1.1 \
		mkdocs-minify-plugin>=0.2 \
		mkdocs-git-revision-date-plugin==0.3.1 \
		pymdown-extensions>=9.9.1 \
		mkdocs-git-revision-date-localized-plugin \
		mkdocs-glightbox \
		mkdocs-blogging-plugin \
        livereload
