# SpotZoo Project: PennAppsXXII at the University of Pennsylvania
- Top 9 Project Overall
- Won Sponsored Route for Best Use of IPFS and/or Filecoin

## Inspiration
**Animals 🐻 are everywhere**, right? Even in Philadelphia, where we have everything from snakes to Coyotes to Bobcats. Though some animals are a man's best friend, like your very own dog, some are the best enemies as well. Humans and nature are always in conflict.

Now, the mess gets worse. Humans are gradually snatching the shelter the habitat of animals and animals are forced to live closer and closer to humans. **Every year, people die due to unexpected and dangerous animal attacks.** Even the animal is injured or killed for the crime of “killing a human”. In rural areas and third-world countries, it's considered common to die due to animal attacks.

Thousands die and millions are left severely injured worldwide by animal attacks. Injuries, too, cost a lot to treat and manage, and in the US alone, treatment of animal injuries costs over $2 billion.

We propose a noble solution to this problem. A *community-driven mobile application* that leverages the cutting-edge power of *ML* & allows to crowdsource real-time information on animal encounters so that other people in that location can avoid a possible animal attack.

Presenting - **SpotZoo**! ✨

![spotzoo.png](https://i.postimg.cc/1XBxLJwB/ggspot.png)

## What it does

**SpotZoo** is a *community-driven ML-powered mobile application that allows users to crowdsource real-time information on animal encounters so that other people in that location can avoid a possible animal attack.*

> Through our app, users can provide photos of animals they saw or encountered & add them to a geographic database that other users can see. We made a mobile app where users can log in, submit photos (&/or even click them) and then it's deployed to IPFS which later on is fed into a ML model running in the backend to leverage **Computer Vision** which helps in recognizing the object which helps to identify the animal & add the encounter to Firebase realtime database. We also utilize Google maps API's to provide an interactive, location-based viewer for encounters and alerts when you might be getting close.

##### Summarised Workflow
After successfully logging in, the app requests to share your current location. While reporting an animal you upload an image of that animal and the app immediately recognizes the animal. You add more info's like, *time spotted*, *number of animals* etc. After submitting the location of the animal is posted on the interactive map along with the spotting info. All other users within a 5km radius are notified about the animal, they can see it's picture and the time spotted. Henceforth, they will get alerted and take precautions and not go near the spotted place.

---

## How we built it
The app is pretty complex and took lots of effortful hours to make it. Let's divide the app into 3 categories:

1. **Frontend** - The app was designed in Figma, and then the frontend was coded in Flutter.  We use Google Maps API to fetch user's locations and show alerts within a 5km radius. The user authentication was done with *Firebase*.

2. **ML Model** - We used MobileNet V2 SSD to build our Machine learning model. We gathered over 1000+ images approximately 2 GB of data and the model was trained 150,000 times. After this, we reached an accuracy of 92%. The ML model was then integrated into the backend

![ML-architecture.jpg](https://i.postimg.cc/FzgcmQnc/ML-architecture.jpg)

3. **Backend** - Time constraint was a big issue for all of us. Thus we decided to proceed with firebase/firestore as our database and had an independent node js/express backend running on the Google App Engine. 
![tech stack](https://cdn.discordapp.com/attachments/886064343660249090/886576541163724820/SpotZoo_-_techStack.png)

---

##### Detailed Workflow

**The perspective of a spotter USER 1:**

The spotter opens the app. Instantly the app demands his location and then it’s fetched by Google Maps API and stored in the firebase. He then goes to report a spotting then selects an image/video from his phone and uploads it to the app. The app instantly stores it in Firebase. Then the API detects that a new image has been uploaded, it fetches that image from Firebase and sends it to the ML model hosted at Google app engine (https://spotzoo.uc.r.appspot.com) and the image would run through the model which then will return a response with an animal name & it's prediction confidence. The API would bring back the `animal_name` and store it with along `animal_description`, `animal_time` and `animal_location`. After this, there would be a message which pops up to the user that (“**ALERT CREATED**”)

Node. js-Express App image upload endpoint 

- ML model(Tensorflow - Mobilenetv2 SSD) to classify the animal.
- Upload image on IPFS  & get HashCode/Path (CID) which can be used to access the image.
- Store animal report data upload to Firestore.

##### So, why IPFS?
We used IPFS to protect the **mutability** of the image and make it **more secure** and easy to transfer. We had an ML model to verify that the image is an animal only and enhance authenticity of the app.

IPFS or *Interplanetary File System* is a p2p filesharing system that aims to fundamentally change the way information is distributed across the Web. For normal use cases, we can store data in centralized servers and can access the same by location-based addressing. This might make it easier to manage data, but there are many weaknesses in the realms of security, privacy and efficiency. IPFS provides **high throughput**, **low latency data distribution**. It is also **decentralized** and **secure**.


## Challenges we ran into
A lot! Initially, we were facing a problem setting up the TensorFlow model on our project as it was a very buffed one and flutter doesn't accept this format so we had to reduce the dataset parameters & then optimize it so that it can run seamlessly with low latency. Then creating an API endpoint was also a big issue.  

## Accomplishments that we're proud of
We have successfully implemented an application that can help people survive in devastating situations of encountering animals and allow people to discover animals around them at the same time. Moreover, we have orchestrated high-end technologies including Cloud, IPFS, and a Machine Learning model to thoroughly build our application. Consequently, we are proud of finishing the project on time which seemed like a tough task as we started working on it quite late due to other commitments and were also able to add most of the features that we envisioned for the app during ideation. And as always, overnight working was pretty fun! :)

## What we learned
A lot of things, both summed up in technical & non-technical sides. Also not to mention, we enhanced our googling and Stackoverflow searching skill during the hackathon. We need to work on time management skills as well😆.

## What's next for SPOTZOO
We just really want this project to be a real app and have an impact! Still, we would love to make it more scalable & cross-platform so that the user interaction increases & we can help minimize unexpected animal attacks.

#### Check out this [doc](https://docs.google.com/document/d/1fc9_9zpepgL_NWGGUn5luJ0TSj33h51x6V4yGZpDbqQ/edit#) for more info!
For related code that is part of this project, check out [this github repo](https://github.com/sjunhong/PennAppsXXII-SpotZoo/tree/main/app)
