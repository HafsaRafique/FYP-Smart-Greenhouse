# Smart Greenhouse

A Final Year Project that uses AI for automated plant health monitoring and yield prediction in greenhouse environments. The system is designed to assist farmers and researchers by identifying diseases early and estimating plant productivity using deep learning and machine learning models.

---

## Project Summary

Traditional greenhouse farming relies heavily on manual inspection, which is labor-intensive and error-prone. This project introduces a smart AI-driven system that:

- Detects diseases in **tomato**, **chilli**, and **lettuce** plants using CNNs and Vision Transformers.
- Predicts crop yield using hybrid models, XGBoost, and stacked ensemble learning.
- Provides an interactive **Flutter-based mobile app** for disease diagnosis and yield estimation.
- Deploys model APIs using **Flask**, **Docker**, and **Azure Cloud** for seamless integration.

---

## Key Features

- Image-based disease detection
- Yield prediction using environmental data
- Trained on public datasets (Kaggle & OpenData Pakistan)
- User-friendly Flutter frontend
- Flask-based REST APIs deployed on Azure
- Offline login using Hive DB

---

## Tech Stack

| Component         | Technologies |
|------------------|--------------|
| Disease Detection | CNN, AlexNet, ViT |
| Yield Prediction  | XGBoost, CNN-LSTM, CNN-DNN |
| Web APIs          | Flask, Docker, Azure Container Instance |
| Frontend App      | Flutter, Hive (local DB), ImagePicker |
| Tools & Services  | Python, Postman, Colab, GitHub, Kaggle |

---

## Models Used

| Task                  | Model Used                  |
|-----------------------|-----------------------------|
| Tomato Disease        | AlexNet                     |
| Chilli Disease        | CNN                         |
| Lettuce Disease       | Hybrid Vision Transformer   |
| Tomato Yield          | XGBoost                     |
| Lettuce Yield         | XGBoost                     |
| Chilli Yield          | Stacked Ensemble            |

---

## Notes
The models are hosted on Azure Cloud, although the container is usually stopped. Models can be provided on request.
