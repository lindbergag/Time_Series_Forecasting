if (!require("tidyverse")) install.packages("tidyverse")
library(tidyverse)
if (!require("rtweet")) install.packages("rtweet")
library(rtweet)

# whatever name you assigned to your created app
appname <- "podtestapp"

## api key (example below is not a real key)
key <- "XXXXXXXXXXXXXXXXXXXXXXXXX"

## api secret (example below is not a real key)
secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

##access token
access_token = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

## access secret
access_secret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# create token named "twitter_token"
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)


## Took this list from Lunar Crush's list of Most Followers and Most Influential. Removed Protocols and users that primarily
## https://lunarcrush.com/
## use a language other than English

influencers1 <- c("0x_Messi", "0xd0n", "1gwilo", "adrian__chamber", "alexandomega", "AltcoinGordon", "AltcoinSherpa", "AltCryptoGems",
                  "Astrones2", "BackpackerFI", "beastlyorion", "BillyBobBaghold", "Bitboy_Crypto", "bricepromos", "CanteringClark",
                  "carlo_armilo", "ChadCaff", "crypto_coochie", "crypto_iso", "CryptoArch1tect", "CryptoCapo_")
influencers2 <- c("CryptoDiffer", "CryptoFinally", "CryptoGodJohn", "cryptohomii", "cryptomanran", "CryptoNewton", "CryptoTony_", 
                  "DannyCrypt", "deficryptofarm", "DefiWiz", "digitalassetbuy", "eliz883", "ftm_ecologist", "FTMAlerts", "Gojo_Crypto", 
                  "hackapreneur", "IncomeSharks", "jackniewold", "JamesPelton18", "JumperWave", "kale_abe", "KateMillerGems")
influencers3 <- c("KingsFantom", "klaraliron", "ladycryptook", "litterthanli7", "LomahCrypto", "MarcusButler", "markjeffrey",
                  "michelle_crypto", "milesdeutscher", "missufe", "moneywithcarter", "MoonSkyCrypto", "Mrbankstips", "MuroCrypto",
                  "Ninjascalp", "Onecryptobreak", "PaikCapital", "PassivePaulie", "PrimeXBT", "producer_fred", "PsyJayCrypto", 
                  "RemiPromotes")
influencers4 <- c("ReySantoscrypto", "Route2FI", "ScottMelker", "selena_royf", "selenaroyf", "ShardiB2", 
                  "Sheldon_Sniper", "SmartContracter", "TeddyCleps", "TheBreadmakerr", "TheCoffeeBlock", "thecryptodawg", 
                  "TheCryptoDog", "TheCryptoLark", "TheDefiJedi", "thegreatola", "TheMehulPatel", "TheMoonCarl", "Trader_XO", 
                  "Tweak896", "WisdomMatic", "WSB_Chairman")

#Collect Users Timelines
infleuncers1tweets <- get_timelines(influencers1, n = 3200)
infleuncers2tweets <- get_timelines(influencers2, n = 3200)
infleuncers3tweets <- get_timelines(influencers3, n = 3200)
infleuncers4tweets <- get_timelines(influencers4, n = 3200)

#Join the timelines into one tibble
tweets <- bind_rows(infleuncers1tweets, infleuncers2tweets)
tweets <- bind_rows(tweets, infleuncers3tweets)
tweets <- bind_rows(tweets, infleuncers4tweets)

#Backup Raw Data
write.csv(tweets, file="influencerdata_raw.csv", fileEncoding = "UTF-8")

#Backup
dirty.tweets <- tweets

#For some reason media_type is of type list... no biggie
tweets <- tweets %>%
  unnest_wider(media_type)


#Look at how many tweets are different media types
tweets %>%
  count(...1)

#Isolate only the media types that are NA
tweets <- tweets %>%
  filter(is.na(`...1`))

#Cross-Reference the second column of media-types
tweets %>%
  count(`...2`)

#Cross-Reference media-url to see if this column has any value
tweets %>%
  count(media_url)

#What are the names of all of the columns
names(tweets)

#Isolate only the columns we think might be useful
tweets <- tweets %>%
  select(status_id, created_at, screen_name, text, display_text_width, reply_to_status_id,
         reply_to_screen_name, is_quote, is_retweet, favorite_count, retweet_count,
         hashtags, symbols, mentions_screen_name, quoted_status_id, quoted_text,
         quoted_created_at, quoted_source, quoted_favorite_count, quoted_retweet_count,
         quoted_screen_name, quoted_name, quoted_followers_count, quoted_friends_count, quoted_statuses_count,
         retweet_status_id, retweet_text, retweet_created_at, retweet_favorite_count, retweet_retweet_count,
         retweet_screen_name, retweet_name, retweet_followers_count, retweet_friends_count,
         retweet_statuses_count, name, followers_count, friends_count, listed_count, statuses_count,
         favourites_count, account_created_at)


#Backup only what we're interested in
dirty.tweets <- tweets
#Backup Data
write.csv(tweets, file="influencerdata_partial.csv", fileEncoding = "UTF-8")


#Hashtag variables are lists. Let's unnest that
tweets <- tweets %>%
  unnest_longer(hashtags)
#Symbol variables are lists, let's unnest that
tweets <- tweets %>%
  unnest_longer(symbols)
#Mentions screen name are lists. unnest that
tweets <- tweets %>%
  unnest_longer(mentions_screen_name)


#Backup Clean data
write.csv(tweets, file="influencerdata_clean.csv", fileEncoding = "UTF-8")
