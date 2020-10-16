# set base image (host OS)
FROM python:3.8

# copy the dependencies file to the working directory
COPY requirements.txt requirements.txt

#EXPOSE 80

# install dependencies
RUN pip install -r requirements.txt

# set the working directory in the container
WORKDIR /code

## copy the content of the local src directory to the working directory
COPY main.py main.py

#RUN mkdir SSBGETData

COPY ./SSBGetData/GetDataFromSSB.py /code/SSBGetData/GetDataFromSSB.py
COPY ./databaseconnection/addtodatabase.py /code/databaseconnection/addtodatabase.py
# command to run on container start
ENTRYPOINT ["python", "main.py"]
