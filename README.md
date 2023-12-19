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

At the first time of execution it may ask you to verify a DataDome captcha. Once verified you may use `ComTheTrainLine.find` for one year without any problem.

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

