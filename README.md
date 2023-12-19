### Demo

![Demo](demo/trainline-bot-example.gif)


### Installation

~~~
# Build image
docker build -t trainline .
~~~

### RUN

~~~
# Create a container
docker run -it --rm -v "$(pwd)":/usr/src/trainline -w /usr/src/trainline trainline
~~~

### Examples

During the initial execution, you might encounter a DataDome captcha verification prompt. Once successfully verified, you should ideally be able to utilize ComTheTrainLine.find without any interruptions for a year. However, there's a possibility that it may prompt you for reverification if it detects any suspicious activity.

#### Example 1

~~~
ComTheTrainLine.find('London', 'Paris', DateTime.new(2023, 12, 31, 17, 0, 0))
~~~

#### Example 2

~~~
from = "London"
to = "Paris"
depart_at = DateTime.new(2023, 12, 31, 17, 0, 0)
cttl = ComTheTrainLine.new
cttl.bot(from, to, depart_at)
~~~

### Cookie Management (Optional)
You may read/write the datadome cookie in `.datadome_cookies` under root folder of the project
