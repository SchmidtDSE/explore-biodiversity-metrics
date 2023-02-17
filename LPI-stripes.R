# remotes::install_github("Zoological-Society-of-London/rlpi")
library(rlpi)
library(tidyverse)

df <- read_csv("https://figshare.com/ndownloader/files/7012670")
df |> count(Method, sort=TRUE)


f <- system.file("extdata", "example_data.zip", package = "rlpi")
unzip(f)


ex <- read_tsv("example_data/terrestrial_class_nearctic_infile.txt")
Nearc_lpi <- LPIMain("example_data/terrestrial_class_nearctic_infile.txt", use_weightings = 1, VERBOSE=FALSE)

terr <- LPIMain("example_data/terrestrial_infile.txt", use_weightings = 0, VERBOSE = FALSE)

lpi_df <- terr |> 
  rownames_to_column("year") |> 
  as_tibble() |> 
  mutate(year = as.integer(year)) |> 
  filter(LPI_final > -99)
  

lpi_df |>
  ggplot(aes(year, LPI_final)) + geom_line() + geom_ribbon(aes(ymin=CI_low, ymax=CI_high), fill="blue", alpha=0.1)

lpi_df <- lpi_df |> mutate(sample = LPI_final + ((CI_high - CI_low)/2) * (runif(n(), -10,10))/10 )



direct <- read_csv("https://www.livingplanetindex.org/session/2ccf2bec98c16e6ee8f9ed6bbd8a514d/download/downloadData?w=")
direct |>
  ggplot(aes(Year, LPI_final)) + geom_line() + geom_ribbon(aes(ymin=CI_low, ymax=CI_high), fill="blue", alpha=0.1)

set.seed(1234)
direct |> rename(year = Year) |>  mutate(sample = LPI_final + ((CI_high - CI_low)/2) * (runif(n(), -10,10))/10 ) |> 
  drop_na() |>
ggplot(aes(x = year, y = 1, fill = sample)) +
  geom_tile(show.legend = FALSE) +
  #scale_fill_steps2(low = "#c7cca5", mid="#ddff03", high="#53de02", midpoint = median(lpi_df$LPI_final)) + 
  scale_fill_stepsn(colors = c("#c7cca5", "#ddff03", "#53de02"), values = rescale(c(min(lpi_df$sample), 0, max(lpi_df$sample))),
                    n.breaks = 100) + 
  coord_cartesian(expand=FALSE) +
  scale_x_continuous(breaks=seq(1970, 2020, 49)) +
  labs(title= glue("Living Planet Index")) +
  theme_void() +
  theme(
    axis.text.x = element_text(color="white",
                               margin =margin(t=5, b=10, unit="pt")),
    plot.title = element_text(color="white",
                              margin =margin(b=5, t=10, unit="pt"),
                              hjust= 0.05),
    plot.background = element_rect(fill="black")
  )


#full_lpi <- LPIMain("LPI2016.csv", use_weightings = 1, VERBOSE=FALSE)
