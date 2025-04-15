# app/modelos/modelo_skin.py
import torch
from torch import nn, optim
from torchvision import models
from pytorch_lightning import LightningModule
from torchmetrics.functional import accuracy

class SkinTypeClassifier(LightningModule):
    def __init__(self, num_classes=6, lambda_weight_decay=1e-6):
        super().__init__()
        base_model = models.resnet34(weights=models.ResNet34_Weights.IMAGENET1K_V1)
        for param in base_model.parameters():
            param.requires_grad = True
        self.feature_extractor = nn.Sequential(*list(base_model.children())[:-1])
        self.feature_extractor_out_features = base_model.fc.in_features
        self.classifier = nn.Sequential(
            nn.AdaptiveAvgPool2d((1, 1)),
            nn.Flatten(),
            nn.Dropout(0.3),
            nn.Linear(self.feature_extractor_out_features, 256),
            nn.ReLU(),
            nn.BatchNorm1d(256),
            nn.Dropout(0.5),
            nn.Linear(256, num_classes),
        )
        self.automatic_optimization = False
        self.lambda_weight_decay = lambda_weight_decay
        self.criterion = nn.CrossEntropyLoss(label_smoothing=0.1)

    def forward(self, x):
        x = self.feature_extractor(x)
        x = self.classifier(x)
        return x

    def configure_optimizers(self):
        base_opt = optim.AdamW(filter(lambda p: p.requires_grad, self.feature_extractor.parameters()), lr=1e-4)
        head_opt = optim.AdamW(self.classifier.parameters(), lr=1e-3, weight_decay=self.lambda_weight_decay)
        return [base_opt, head_opt]

    def training_step(self, batch, batch_idx):
        images, labels = batch
        outputs = self(images)
        loss = self.criterion(outputs, labels)

        base_opt, head_opt = self.optimizers()
        base_opt.zero_grad()
        head_opt.zero_grad()
        self.manual_backward(loss)
        base_opt.step()
        head_opt.step()

        preds = torch.argmax(outputs, dim=1)
        acc = accuracy(preds, labels, task='multiclass', num_classes=6)

        self.log('train_loss', loss)
        self.log('train_acc', acc)
        return loss

    def validation_step(self, batch, batch_idx):
        images, labels = batch
        outputs = self(images)
        loss = self.criterion(outputs, labels)
        preds = torch.argmax(outputs, dim=1)
        acc = accuracy(preds, labels, task='multiclass', num_classes=6)

        self.log('val_loss', loss)
        self.log('val_acc', acc)
        return loss