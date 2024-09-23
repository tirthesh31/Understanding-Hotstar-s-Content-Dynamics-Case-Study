# Clear the environment
rm(list = ls())

# Load necessary packages and install if not already installed
required_packages <- c("Hmisc", "dplyr", "ggplot2", "tidyr")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Read the CSV file (update the path as per your local setup)
data <- read.csv("~/Data Analysis/hotstar.csv")

# Duplicate the 'seasons' and 'episodes' columns and replace NAs with 1
data <- data %>%
  mutate(
    seasons_dup = ifelse(is.na(seasons), 1, seasons),
    episodes_dup = ifelse(is.na(episodes), 1, episodes)
  )

# Display the first few rows of the modified data
head(data)

# Optionally describe the updated data
describe(data)

# 1. Determine which type has comparatively high production
production_summary <- data %>%
  group_by(type) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count))

# Plot production by type
ggplot(production_summary, aes(x = reorder(type, -Count), y = Count, fill = type)) +
  geom_bar(stat = "identity") +
  labs(title = "Production by Type", x = "Type", y = "Count") +
  theme_minimal()

# 2. Identify titles with the highest and lowest running time
running_time_summary <- data %>%
  filter(!is.na(running_time)) %>%
  arrange(running_time)

# Display titles with highest and lowest running time
highest_running_time <- tail(running_time_summary, 1)
lowest_running_time <- head(running_time_summary, 1)

print("Title with the Highest Running Time:")
print(highest_running_time)

print("Title with the Lowest Running Time:")
print(lowest_running_time)

# Plot running time by genre instead of title
data_separated <- data %>%
  separate_rows(genre, sep = ",") %>%
  group_by(genre) %>%
  summarize(
    max_running_time = max(running_time, na.rm = TRUE),
    min_running_time = min(running_time, na.rm = TRUE)
  ) %>%
  arrange(desc(max_running_time))

# Plot maximum running time by genre
ggplot(data_separated, aes(x = reorder(genre, -max_running_time), y = max_running_time)) +
  geom_point(color = "blue") +
  labs(title = "Maximum Running Time by Genre", x = "Genre", y = "Running Time (minutes)") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        plot.margin = margin(5, 5, 20, 5))

# 3. Show the number of movies or TV shows produced each year
yearly_production <- data %>%
  filter(!is.na(year)) %>%
  group_by(year, type) %>%
  summarize(Count = n())

# Plot production by year
ggplot(yearly_production, aes(x = year, y = Count, color = type)) +
  geom_line() +
  labs(title = "Number of Movies/TV Shows Produced Each Year", x = "Year", y = "Count") +
  theme_minimal()

# 4. Count the number of titles by genre
genre_count <- data %>%
  separate_rows(genre, sep = ",") %>%
  group_by(genre) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count))

# Plot number of titles by genre
ggplot(genre_count, aes(x = reorder(genre, -Count), y = Count, fill = genre)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Titles by Genre", x = "Genre", y = "Count") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 8), # Adjust text size and position
    plot.margin = margin(5, 5, 20, 5)  # Increase the bottom margin to provide space
  )

# 5. Find the title with the maximum seasons
max_seasons_title <- data %>%
  filter(!is.na(seasons)) %>%
  arrange(desc(seasons)) %>%
  slice(1)  # Get the first row with the maximum seasons

# Display the title with maximum seasons
print("Title with the Maximum Seasons:")
print(max_seasons_title)

# 6. Find the title with the maximum episode
max_episode_title <- data %>%
  filter(!is.na(episodes_dup)) %>%
  arrange(desc(episodes_dup)) %>%
  slice(1)  # Get the first row with the maximum seasons

# Display the title with maximum seasons
  print("Title with the Maximum Seasons:")
  
# 7.Count the number of titles by genre for each age rating
  genre_age_rating <- data %>%
    separate_rows(genre, sep = ",") %>%
    group_by(age_rating, genre) %>%
    summarize(Count = n()) %>%
    arrange(age_rating, desc(Count))
  
  # Display the summarized data
  print(genre_age_rating)
  
  # Plot number of titles by genre for each age rating
  ggplot(genre_age_rating, aes(x = reorder(genre, -Count), y = Count, fill = age_rating)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(title = "Number of Titles by Genre and Age Rating", x = "Genre", y = "Count") +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      plot.margin = margin(5, 5, 20, 5)
    )
  
