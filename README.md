# Important commands

~~~
docker build -t trainline .
#docker run -it --rm -v "$PWD":/usr/src/trainline trainline ruby trainline_bot.rb
docker run -it --rm -v "$(pwd)":/usr/src/trainline -w /usr/src/trainline trainline bash
~~~
