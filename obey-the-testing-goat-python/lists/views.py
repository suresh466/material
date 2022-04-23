from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home_page(request):
    template = 'lists/home.html'
    context = {'new_item_text': request.POST.get('item_text', ''),}

    return render(request, template, context)
