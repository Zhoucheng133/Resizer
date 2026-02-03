# Resizer

Also available in English. Click [HERE](/documents/en.md) to view the English version of the README

## 简介

<img src="assets/icon.png" width="100px">

![License](https://img.shields.io/badge/License-MIT-dark_green)

<a href="https://apps.microsoft.com/detail/9n5fp6mgwwlg?referrer=appbadge&mode=direct">
	<img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>


这是一个调整图片尺寸的工具，支持使用JSON脚本添加多个输出尺寸

核心组件的仓库[在这里](https://github.com/Zhoucheng133/Resizer-Core)

## 截图

<img src="demo/cn.png" width="600px">

## 脚本格式

你可以参考示例脚本[sample.json](demo/sample.json)

```JSON
{
  "name": <多任务名称>,
  "tasks": [
    {
      "path": "output.png",
      "width": <宽度(像素), 0表示自动>,
      "height": <高度(像素), 0表示自动>
    },
    {
      "path": "output_16x16.png",
      "width": 16,
      "height": 0
    },
    // ...
  ]
}
```