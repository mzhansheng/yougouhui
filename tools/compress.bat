@echo off
echo ��ǰ�̷���%~d0
echo ��ǰ�̷���·����%~dp0

cd %~dp0
echo ���ڿ���Ŀ¼��mobile��
XCOPY /s /Y "../server/src/public" "../mobile/www" 

rd "../mobile/www/app" /s /q
rd "../mobile/www/upload" /s /q
rd "../mobile/www/yougouhui.esproj" /s /q

cd %~dp0

echo ���ڻ���css�ļ�
for /R ../mobile/www/css/ %%s in (*.css) do (
  echo �ļ�: %%s
  java -jar yuicompressor-2.4.8.jar -o '.css$:-min.css' %%s --charset utf-8
)

echo ���ڻ���js�ļ�
for /R ../mobile/www/js/ %%s in (*.js) do (
  echo �ļ�: %%s
  java -jar yuicompressor-2.4.8.jar -o '.js$:-min.js' %%s --charset utf-8
) 

echo �������

cd ../mobile
echo ��������cordova prepare
cordova prepare


pause
