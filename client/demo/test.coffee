
#这是注释

###
  这是多行注释
###

#变量定义 coffee中不需要使用var关键字定义变量
# 每一句代码占一行  不需要加;
a =10
str = 'abc'
console.log "变量a="+a
# coffee中定义的变量默认都是局部变量

isRight=true

#凡是代码有层级关系时,都要严格缩进2个空格
#定义对象时,不需要加{},而是靠严格的缩进体现属性和对象的关系
obj =
  name : 'tom'
  age :19

aaa=18

# 定义函数 coffee中函数的返回值就是最后一句代码
# 调用函数时 ()可以省略
f1 = (num1,num2)->
     num1+=4
     console.log num1
     num1+num2

result = f1 10,20

console.log result
#给函数参数赋默认值
f2 = (num1,num2=20)->
    console.log(num1+num2);

f2 30
f2 30,10

# if条件
# 后置if语句

if(obj.age>18)
  console.log(obj.name)

#后置if是一行写完
console.log obj.name if obj.age>18
console.log  obj.name unless  obj.age>18

#普通if 要换行缩进
if obj.age>18
  console.log obj.name

#推荐使用is做等于判断  会翻译成js的===
if obj.name is 'tom'
  obj.pwd='123'
  console.log '用户名对'
else if obj.name is 'jack'
  obj.pwd='abc'
  console.log '系统用户'
  if obj.age>20
    console.log('已成人')

#定义数组

arr =[1,2,3,4,5,]

# 循环

for  num  in  arr
  if num%2 is 0
    console.log num+'是偶数'
  else
    console.log num+"是奇数"

