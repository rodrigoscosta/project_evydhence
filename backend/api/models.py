from django.db import models

# Create your models here.

class Person(models.Model):
    idClient = models.IntegerField(primary_key=True)
    nomeRazao = models.CharField(max_length=100)
    cpfCnpj = models.CharField(max_length=16)
    rg = models.CharField(max_length=16)
    dataNascFund = models.CharField(max_length=10)
    email = models.EmailField()
    confirmarEmail = models.EmailField()
    telefone = models.CharField(max_length=11)
    body = models.TextField()
    updated = models.DateTimeField(auto_now=True)
    created = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.nomeRazao
    
    class Meta:
        ordering = ['-updated']