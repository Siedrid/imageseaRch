# Image search

library(rvest)
library(RCurl)

# Issues ----

# size and resolution of images
# visualize images

# Function to download images
download_images <- function(search_term, num_images, WRITE = T) {
  # Construct Ecosia search URL
  search_url <- paste0("https://www.ecosia.org/images?addon=edge&addonversion=5.1.4&q=", search_term, "&size=large")
  
  # Retrieve HTML content
  html <- read_html(search_url)
  
  # Extract image URLs
  image_urls <- html %>% html_elements("img") %>% html_attr("src")
  
  # Filter out any NA values
  image_urls <- na.omit(image_urls)
  
  if (WRITE) {
    if (!dir.exists(search_term)){
      dir.create(search_term)
    }
    # how many files already exist
    n <- length(list.files(search_term))
    
    # Download images
    for (i in 1:min(num_images, length(image_urls))) {
      download.file(image_urls[n+i], paste0(search_term, '/', search_term, "_", n+i, ".jpg"), mode = "wb")
      
      Sys.sleep(1)  # Sleep for a second to avoid overloading the server
    }
    cat("Downloaded", min(num_images, length(image_urls)), "images\n")
  }
  return(image_urls[1:num_images])
}

# Example usage:

search_term <- "goose"  # Your search term
num_images <- 5  # Number of images to download
download_images(search_term, num_images)

