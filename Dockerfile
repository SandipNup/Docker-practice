#BUILD PHASE

#by putting on as builder that means from this FROM command and everything underneath it going to referred as builder phase 
#the purpose of this phase will be to intsall dependencies and build our application
FROM node:alpine as builder

#setting up the working directory inside the container
WORKDIR /app

#copying package.json file from the local machine to filesystem inside the container
COPY package.json .

#install all the dependencies
RUN npm install

#copy everything from the local machine to filesystem inside the container
COPY . .

#to build the production version of an application
RUN npm run build 

# Inside container   /app/build has all the stuff that we care about




#RUN PHASE

#using nginx image
#using second FROM statement specifies the ending of the previous block. The single block has single from statement
FROM nginx


#COPY --from=builder means we want to copy something from different phase(builder)
#  /app/build we want to copy from build folder 
#  /usr/share/nginx/html we want to copy build folder to  /usr/share/nginx/html  
# satitc files in this folder /usr/share/nginx/html will be serverd by nginx server

COPY --from=builder /app/build /usr/share/nginx/html


#the default command of nginx image is going to start nginx server for us so we dont need to specify the startup command


#We are using the multi-step build process...when we are copying something from the previous step 
#every things from the previous step (node image,dependencies) all is dropped off so when we copy 
# build directory everything else is dropped off and we then we start nginx server