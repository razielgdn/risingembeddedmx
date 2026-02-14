---
title: "Yocto Project, Again"
layout: article
tags:
- hobbies
- blog
- yocto
---
<!-- In this file i need help to improve my grammar conserving my stile of writting and jokes
translation of prometida: fiancée
-->

# Yocto Project, Again

## Why I was away last months?
### Finally I have a job

A long time has passed since my last update. The root cause: I've had a job since August. 
This time has been so busy with my new job and I need to focus my energy to learn and adapt to this new environment. 
I enrolled at Aptiv in TCM Monterrey. 

I am in a BCM again. I believe that I don't said before what I did in Dextra, well I do in the about of this blog but if you are here for the histories you probably never seen these section I mean if I was reading a kind of engenering blog I would never read who the hell is the author and what he does to live. However I will say it to generate a lot of text to steal some more seconds of your life time hahaha. 

### Stories from the past
In Dextra technologies(a Deloitte business)(RIP) I was a "software mercenary" My friends and I were contracted to do the work that Continental (RIP) can't do (or don't want to do). 
I was working in an old BCM project to vehicles of a famous brand of cars. I arrived to the project in the middle of the coronavirus pandemic and I was working in a scheme of work where I would only go to the office when it was absolutely necessary (or when the hot weather in Monterrey was so bad I had to pay for the cooling by myself). 

Well in Dextra I worked for 3 years in a **BCM (Body Control Module)** project. This ECU is responsible for controlling the lights, chime, controls the starting of the engine and basically operates most of the communications inside the car performing the signal gateway function. Like the modem in your house, but for the car.
My functions was basically dicuss with the customer about the requirements, implements software features, do lots of testing and debugging of his components, when I started there I was a Junior developer and I was ascending by elimination every comrade that was convinced for another organization to get more money or better conditions my salary was increasing an I need to learn a lot of things to sold the technical problems that I had to solve. At the end of the project only my friend **Joaquin** and I were the responsibles for the maintanance of the project, the training of the new continental and capgemini engineers that were coming and the solution fo the issues.

When the project ends I was transferred to a Light and Braks controls unit project with less responsabilities and when I collaborate with another old friend **Felipe** a very good comrade that I met in my first job as embedded developer in Code Ingenieria(RIP) his **"Pinche chilango"** heates me because I am more sociable than him to peform  the disgusting act of talk with him in the first day with naturality and don't call him "boss" or "sir" and I take borrowed his best friend "Arturo" to go to take beers. Hehe stories for another day.

> Joaquin, Mi brother Abner and I are now working in the same company again and we bet that Felipe will be here in Aptiv or almost in Monterrey soon as he believes. 

Well in the Lights and breaks module I was my first approach to AUTOSAR and I learing some things about this architecture and
the correct way to implement software componenets following the standard. Barely a year layer Deloitte decided to end the contracts with old Dextra customers and I was supporting internal projects until the great layoffs in February 2024. (most of the history after it are documented in this blog) 

## Returning to the main tale: new job, new (old) challenges
I was contracted by Aptiv in the same position as I was in Dextra but in a different (almost the same) BCM project, the famous brand of car contracts aptiv to develop the BCM succesor of the continental project, an cuious fact are that the engineers in the side of the brand of cars are the same that I worked in the past. However the project is structured in a different way, and it implements AUTOSAR from the beginning that is a challenge for me. 
Besides the practices has management, documentation and the way to work is different, I need to adapt to this new environment and learn a lot of things about the project and the company.

The only one thing that I don't like so mucho of this company is that my salary decrease in comparison with my previous job. We have good benefits however Dextra get used to retribute with the just and more.  

### And my personal life continues changing  
Also, as you know I am experimenting a new lifestyle because I am living with my girlfriend (fiancée) and I need to adapt to this new life too you know, One of his enemy are my PC and the time of huges is more important to develop a custom Linux distribution hehe. 

However, my actual salary is not enough to pay for all the things that Adrianita needs to be happy and I need to find a way to increase my income, maybe with some freelance work or something like that. Adding the fact that we are planning to get married this year I need to find the way to improve my financial situation.

The job market in this moment is no the best for embedded developers, also the fact that I am not a senior developer yet cuts my options to find a better yob in an automotive company. 

I was thinking in a solution to this problem, after investigate options I found that the industry of AI is growing a lot however I don't have the knowledges for this field also I think "What need the AI to run" a computer, and what is the cheap way to get a computer? An embedded system that allows to run AI models/services. And the system that allows it is Linux, Embedded Linux.

I am a luky guy because I have some experience in this fiel using Yocto project to develop Linux distributions, I have been using Linux since 2008 and I live in Monterrey where the nearshoring  is growing.

Well I need to sharp my skills in this field and get the way to increase my income with my hobbies developing for embedded Linux. 
Maybe will be titanic effort because I need to I need to find time to pass with Adri,I need to solve my job duties at Aptiv,
and I need to improve my embedded Linux skills.  

I don't need to sleep so much. The day shall have 30 hours. 

## New old Project with Yocto

Las week I start to work in a new project using Yocto. In the past I developed a recipe to build a custom Linux distribution to run in a Raspberry Pi 4, it has a ssh server, non-gui and a minimal set of tools with a demo of a kernel module.

The first steps was create a container to build the project, I use docker for this, I create a dockerfile with the necessary tools to build the project and I create a container with it. Then I add the custom recipe to create my custom Linux distribution called "Rising-Embedded-MX-OS" the main idea is learn the components in a Linux distribution, use it has a learning platform and portfolio to show my skills in this field.

The project is in the early stages, I need to learn a lot of things about Yocto and Linux distributions, but I am excited to start this new adventure and share my progress with you.

I just invite to Felipe and Abner to join me in this project each one of us has a raspberry Pi 4, an AML S905X boards and the 
need of demostrate that we can do something cool as a personal challenge and share that knowledge to the world. 

> Comercial break: pass to the blog of my [friend Felipe] (https://falb18.github.io/tinkering_at_night/) to see his projects and adventures in the world of embedded systems, he is a very good engineer and a great friend, I am sure that you will enjoy his blog as much as I do.

For the next weeks I will be sharing my progress in this project, I will be documenting the steps that I take to build the custom Linux distribution, the challenges that I face and the solutions that I find. 

See you in the next update!