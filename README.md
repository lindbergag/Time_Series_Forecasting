# Time_Series_Forecasting
## Predicting prices of currencies from historical price data and data collected from Twitter using R and Tensorflow.

In this project, I set out to predict the value of the cryptocurrency, [Fantom (FTM)](https://fantom.foundation/) and several of the most popular tokens that are tied to to the Fantom blockchain using R. I started with the idea that data collected from twitter such as tweet volume or sentiment would offer enough information to reliably predict the value of the token in a given time.

## Data Collection

To start, I gathered a list of Twitter users who were labeled as being having the 'Most Followers' and as being the 'Most Influential' in relation to the Fantom blockchain according to the website [Lunar Crush](https://lunarcrush.com). You can see these users name, and how we used Twitter's API to collect as much data as was possible related to their accounts in the [twitter_data_collection.R](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/twitter_data_collection.R) file.

After collecting that data, I did an initial exploratory analysis, looking for tweet volume, hashtag uses, and symbol uses. This exploratory analysis can be seen in the [tweet_data_exploratory.html](https://lindbergag.github.io/Time_Series_Forecasting/tweet_data_exploratory.html) file. One of the first things I noticed is that the most popular hashtags amongst these users were the most popular hashtags for anything cryptocurrency related, as shown in the picture below:
![Most Used Hashtags](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/images/hashes500-.png?raw=true)

Being familiar with the space, I decided to pivot from hashtags to symbols as the symbols for the tokens might be a more specific post, more related to the blockchain I was interested in (Fantom). The picture below still shows a significant usage of token symbols that are not FTM or on the FTM network (btc, eth, avax, dot).
![Most Used Symbols](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/images/symbols500-.png?raw=true)

I used my knowledge of which tokens were on the fantom blockchain and the list of most popular symbols to determine a list of tokens that I wanted to attempt to predict their values.

I then used coingecko's API to collect the hourly price data for all of these tokens. You can see that process in the [crypto_price_data_collection.Rmd](crypto_price_data_collection.Rmd) file.

## Exploratory Analysis
In the [exploratory_analysis](https://lindbergag.github.io/Time_Series_Forecasting/exploratory_analysis.html) file, you can see where I started my initial exploration. Given the assumption that the value of tokens on a blockchain would be related to the value of that blockchain's token, I quickly realized that I needed to start with a focus on the FTM token. 

1. In this file, you'll see where I went through many different iterations of tbats, and arima models, attempting to forecast the price of FTM soley based on the historical ftm price.

2. I then added the number of tweets with the symbol FTM to the the model to see if we could get a better prediction. After many iterations, the best model we could build was the one pictured below:
![Limited Time, Auto Arima, Seasonally Adjusted, FTM price and Tweet Volume](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/images/ftm_limited_auto_arima_forecast_seasonal_c1242840.png?raw=true)

## Exploratory Analysis, Part 2
In the [exploratory_analysis_1](https://lindbergag.github.io/Time_Series_Forecasting/exploratory_analysis_1.html) file, you can see where I started exploring different ideas that may have helped me narrow the confidence intervals from the ARIMA model in my initial exploratory analysis. I asked questions and looked at ideas that I hoped would help me better build a useful model such as: 
* What do the tweet volume and price look like by comparison to their respective moving averages?
* Is there a time of day element that would indicate 'seasonal' data?

## Exploratory Analysis, Part 3
In the [exploratory_analysis_2](https://lindbergag.github.io/Time_Series_Forecasting/exploratory_analysis_2.html) file, you can see where I took the ideas from the previous file and revisted the arima model, trying several different approaches to see if we could get a more narrow confidence interval.

## Long-Short-Term Memory Modeling
In the [LTSM_FTM_Analysis](https://lindbergag.github.io/Time_Series_Forecasting/LTSFM_FTM_Analysis.html) file, you can see where I thought I was at the limits of ARIMA forecasting and decided to start using a deep learning model, LSTM, with disappointing results as depicted below:
![LSTM Forecast](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/images/lstm_forecast.png?raw=true)
![FTM Price Over Time](https://github.com/lindbergag/Time_Series_Forecasting/blob/main/images/actual-price.png?raw=true)

## Requirements
* Python
* R
* R packages
- fable
- forecast
- fpp2
- geckor
- ggplot2
- ggthemes
- gridExtra
- keras *please check tensorflow's website for how to use tensorflow and keras in R*
- lubridate
- reticulate
- rtweet
- SnowballC
- tensorflow *please check tensorflow's website for how to use tensorflow and keras in R*
- Tidyverse
- tm
- xts
- zoo

## Setup
1. Clone the repository
2. Install the required packages 
* You may need dev tools to build some of the packages like geckor and tensorflow
3. Run the scripts

## Contributing

Feel free to fork the repository and submit pull requests with any improvements or bug fixes.

## Results

I ultimately wasn't able to build a model with narrow enough confidence bands that I would use it to invest my money, and that's not terribly surprising. If I were to revisit this project, I would consider the following items:

* The Lunar Crush dataset of 'Most Followers' and 'Most Influential' Twitter users doesn't seem to stand the test of time (the website no longer shows this data). I would revisit what data we collect from Twitter.

* In the same realm of dirty Twitter Data, a lot of hashtags and symbols used on 'crypto-twitter' seem to be following a *search engine optimization* approach in which users assign as many hashtags as possible to a post in hopes that it might attract users interested in something tangentally related to the post. There is probably an entire separate project in trying to determine the degree in which a tweet is actually related to the hashtags a user assigns, whether it matters, and if that approach is successful for the posters.

* The functions provided by the forecast and fpp2 packages I used in this analysis were built to easily train models that look at data with specific structures. Using these tools to try to find patterns (seasonality) in things like time of day and day of week was less than intuitive. I need to either become more versed in the abilities and limits of the provided functions, or develop custom functions.
 

