FROM ruby:3.0.2

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    imagemagick \
    nano \
    yarn \
    git-core \
    curl \
    openssl \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

WORKDIR /app

RUN apt-get update && apt-get install -y tesseract-ocr
COPY Gemfile Gemfile.lock ./
RUN bundle install


COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

COPY . .

EXPOSE 3000

CMD ["./entrypoint.sh"]
