FROM nimlang/nim:2.2.2

WORKDIR /src

COPY . .

RUN cd /src/nim_lang && nimble install -dy

WORKDIR /src/nim_lang
EXPOSE 5000

ENTRYPOINT ["nim", "c", "-r", "src/sist02maker.nim"]