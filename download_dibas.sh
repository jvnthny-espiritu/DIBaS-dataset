#!/bin/bash

# DIBaS dataset download and unzip script
# This script downloads and unzips the DIBaS dataset files sequentially.

urls=(
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Acinetobacter.baumanii.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Actinomyces.israeli.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Bacteroides.fragilis.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Bifidobacterium.spp.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Candida.albicans.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Clostridium.perfringens.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Enterococcus.faecium.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Enterococcus.faecalis.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Escherichia.coli.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Fusobacterium.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.casei.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.crispatus.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.delbrueckii.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.gasseri.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.jehnsenii.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.johnsonii.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.paracasei.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.plantarum.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.reuteri.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.rhamnosus.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Lactobacillus.salivarius.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Listeria.monocytogenes.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Micrococcus.spp.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Neisseria.gonorrhoeae.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Porfyromonas.gingivalis.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Propionibacterium.acnes.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Proteus.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Pseudomonas.aeruginosa.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Staphylococcus.aureus.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Staphylococcus.epidermidis.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Staphylococcus.saprophiticus.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Streptococcus.agalactiae.zip"
    "https://doctoral.matinf.uj.edu.pl/database/dibas/Veionella.zip"
)

download_and_unzip() {
    url=$1
    index=$2
    total=$3
    filename=$(basename "$url")
    foldername="${filename%.zip}"
    echo -e "\e[1;34m[$index/$total] Downloading:\e[0m $filename"
    
    content_length=$(wget --no-check-certificate --spider --server-response "$url" 2>&1 | awk '/Content-Length/ {print $2}' | tail -1)
    
    if [ -n "$content_length" ]; then
        wget --no-check-certificate -q -O - "$url" | pv -s "$content_length" > "$filename"
    else
        echo -e "\e[1;31m[$index/$total] Failed to get content length for:\e[0m $filename. Downloading without progress bar."
        wget --no-check-certificate -q -O "$filename" "$url"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "\e[1;32m[$index/$total] Downloaded:\e[0m $filename"
        echo -e "\e[1;34m[$index/$total] Unzipping:\e[0m $filename"
        
        mkdir -p "$foldername"
        unzip -q "$filename" -d "$foldername"
        
        if [ $? -eq 0 ]; then
            echo -e "\e[1;32m[$index/$total] Unzipped:\e[0m $filename"
            rm "$filename"
        else
            echo -e "\e[1;31m[$index/$total] Failed to unzip:\e[0m $filename"
            rm -r "$foldername"
        fi
    else
        echo -e "\e[1;31m[$index/$total] Failed to download:\e[0m $filename"
    fi
}

total=${#urls[@]}
echo -e "\e[1;33mStarting download and unzip process...\e[0m"
for i in "${!urls[@]}"; do
    download_and_unzip "${urls[$i]}" $((i + 1)) $total
done
echo -e "\e[1;33mAll files downloaded and unzipped successfully.\e[0m"