@echo off
echo ��ǰ�̷���·����%~dp0

cd %~dp0

echo ���ڻ���css�ļ�
for /R ../mobile/platforms/android/assets/www/ %%s in (*.css) do (
  echo �ļ�: %%s
  java -jar yuicompressor-2.4.8.jar -o '.css$:-min.css' %%s --charset utf-8
)

echo ���ڻ���js�ļ�
for /R ../mobile/platforms/android/assets/www/ %%s in (*.js) do (
  echo �ļ�: %%s
  java -jar yuicompressor-2.4.8.jar -o '.js$:-min.js' %%s --charset utf-8
) 

echo �������

pause
