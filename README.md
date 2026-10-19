# Setting for bioinformatics
## 1. R
### 1.1. Setting for using R (Windows)
#### 1.1.1. Install R
1. Access "https://www.r-project.org".
2. Click "CRAN".
3. Select URL depending on your location. Or click "https://cloud.r-project.org".
4. Click "Download R for Windows".
5. Click "Base".
6. Click "Download R-x.x.x for Windows" for download.
7. Run the downloaded file for install R.

#### 1.1.2. Install R studio
1. Access "https://posit.co/download/rstudio-desktop".
2. Click "DOWNLOAD RSTUDIO DESKTOP FOR WINDOWS".
3. Install R studio.

### 1.2. Setting for using R (mac)
#### 1.2.1. Install R
1. Access "https://www.r-project.org".
2. Click "CRAN".
3. Select URL depending on your location. Or click "https://cloud.r-project.org".
4. Click "Download R for macOS".
5. Select R version and click it for download.
6. Run the downloaded file for install R.

#### 1.2.2. Install R studio
1. Access "https://posit.co/download/rstudio-desktop".
2. Select macOS version.
3. Click "DOWNLOAD RSTUDIO DESKTOP...".
4. Install R studio.

### 1.3. Useful packages
```R
install.packages("tidyverse")
install.packages("growthcurver")
```

## 2. Python (Windows)
### 2.1. Install WSL and Ubuntu
1. Open PowerShell as Administrator.
2. Install WSL and Ubuntu.
```PowerShell
wsl --install -d Ubuntu
```

### 2.2. Prepare Ubuntu
1. Open Ubuntu terminal.
2. Refresh the package index.
```Bash
sudo apt update
sudo apt update -y
sudo apt install -y wget ca-certificates
```

### 2.3. Useful packages
```Python
sudo apt install python3-pip python3-venv

conda create -n plasmid python pip
conda activate plasmid
pip install dna_features_viewer
conda deactivate

conda create -n mfa python pip
conda activate mfa
pip install cobra
pip install pandas
pip install openpyxl
conda deactivate
```

### 2.3. Install Anaconda
1. Access "https://repo.anaconda.com/archive" and check the latest anaconda version (e.g. Anaconda3-2026.07-1-Linux-x86_64.sh).
2. Install the latest version.
``` Bash
wget https://repo.anaconda.com/archive/Anaconda3-<version>-Linux-x86_64.sh
sudo bash Anaconda3-<version>-Linux-x86_64.sh
```

## 3. Python (mac)
### 3.1. Install Anaconda
1. Access "https://www.anaconda.com/download/success?reg=skipped".
2. Download "Anaconda Distribution".
3. Install the file.

### 3.2. Install VS Code (mac)
1. Access "https://code.visualstudio.com/download?_exp_download=fb315fc982".
2. Download the installer.
3. Install the VS Code.
4. Run the VS Code.
5. Install Python extension (provided by Microsoft).

### 3.3. Useful packages
```Python
conda create -n plasmid python pip
conda activate plasmid
pip3 install dna_features_viewer
conda deactivate

conda create -n mfa python pip
conda activate mfa
pip3 install cobra
pip3 install pandas
pip3 install openpyxl
conda deactivate
```

## 4. MySQL
### 4.1. Install MySQL (Windows)
1. Access "https://www.mysql.com/".
2. Click "DOWNLOADS".
3. Click "MySQL Installer for Windows". Or you can directly access via this URL: https://dev.mysql.com/downloads/mysql/.
4. Click "MySQL Community Server".
5. Download "mysql-installer-community-x.x.x.x.msi" and run the downloaded file.
6. Choose a setup type as "Custom".
7. Install "MySQL Server" and "MySQL Workbench".
8. Set password. ***Do not forget this password.***

### 4.2. Install MySQL (mac)
#### 4.2.1. Server download
1. Access "https://www.mysql.com/".
2. Click "DOWNLOADS".
3. Click "MySQL Community (GPL) Downloads". Or you can directly access via this URL: https://dev.mysql.com/downloads/installer/.
4. Click "MySQL Community Server".
5. Download and install the server.

#### 4.2.2. Workbench download
1. Access "https://www.mysql.com/".
2. Click "DOWNLOADS".
3. Click "MySQL Community (GPL) Downloads". Or you can directly access via this URL: https://dev.mysql.com/downloads/workbench/.
4. Click "MySQL Workbench".
5. Download and install the workbench.
