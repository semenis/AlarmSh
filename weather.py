import requests, bs4
s=requests.get('https://sinoptik.com.ru/%D0%BF%D0%BE%D0%B3%D0%BE%D0%B4%D0%B0-%D0%BA%D0%B0%D0%BB%D1%83%D0%B3%D0%B0-100553915')
b=bs4.BeautifulSoup(s.text, "html.parser")
p=b.select('.rSide .description')
pogoda=p[0].getText()
print(pogoda.strip())
