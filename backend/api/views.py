from rest_framework.decorators import api_view
from rest_framework.response import Response
from .serializers import PersonSerializer
from .models import Person

# Create your views here.

@api_view(['GET'])
def getRoute(request):
    route = [
        {
            'Endpoint': '/backend/create',
            'method': 'POST',
            'body': {'body': ""},
            'description': 'Cria um novo cadastro e envia por uma requisição POST'
        }
    ]    
    return Response(route)

@api_view(['GET'])
def getPersons(request):
    persons = Person.objects.all()
    serializer = PersonSerializer(persons, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def getPerson(request, pk):
    person = Person.objects.get(idClient=pk)
    serializer = PersonSerializer(person, many=False)
    return Response(serializer.data)

@api_view(['POST'])
def createPerson(request):
    data = request.data
    person = Person.objects.create(
        idClient = data['idClient'],
        nomeRazao = data['nomeRazao'],
        cpfCnpj = data['cpfCnpj'],
        rg = data['rg'],
        dataNascFund = data['dataNascFund'],
        email = data['email'],
        confirmarEmail = data['confirmarEmail'],
        telefone = data['telefone'],
        body = data['body']
    )
    serializer = PersonSerializer(person, many=False)
    return Response(serializer.data)

@api_view(['PUT'])
def updatePerson(request, pk):
    data = request.data
    person = Person.objects.get(idClient=pk)
    serializer = PersonSerializer(person, data=request.data)
    if serializer.is_valid():
        serializer.save()

    return Response(serializer.data)

@api_view(['DELETE'])
def deletePerson(request, pk):
    person = Person.objects.get(idClient=pk)
    person.delete()

    return Response('Cliente excluído!')