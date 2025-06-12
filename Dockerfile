FROM nimlang/nim:1.6.14

WORKDIR /src

COPY . .

RUN cd /src/nim_lang && nimble install -dy

WORKDIR /src/nim_lang
EXPOSE 5000

ENTRYPOINT ["nim", "c", "-r", "-d:ssl","-d:release","--hints:off","src/sist02maker.nim"]