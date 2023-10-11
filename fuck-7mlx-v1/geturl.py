# coding=UTF-8
file = open("reply.html", "r")
content = file.read() 
lines = file.readlines()

#执行替换
new_content = content.replace(" ", "")
new_content = new_content.replace("<htmlid='anticc_js_concat'><body><scriptlanguage='javascript'>var", "")
new_content = new_content.replace("</script></body></html>", "")
new_content = new_content.replace(";", "\n")
new_content = new_content.replace("window.location=url", "print(url)")

#输出结果
tmpresult = open("url.py", "w")
tmpresult.write(new_content)
tmpresult.close()

file.close
tmpresult.close
