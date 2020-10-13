# set base image (host OS)
FROM python:3.8-slim



# copy the dependencies file to the working directory
COPY requirements.txt requirements.txt

#EXPOSE 80

# install dependencies
RUN pip install -r requirements.txt

# set the working directory in the container
WORKDIR /code

# copy the content of the local src directory to the working directory
COPY main.py main.py

COPY ./SSBGetData/GetDataFromSSB.py .
# command to run on container start
CMD ["python", "main.py"]


