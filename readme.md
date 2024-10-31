这是一个MOD示例和 对应参考素材。

用来解决 手柄 虚拟控制 鼠标问题，以实现各种花样的自定义HUD界面的点击交互。

控制台输入  

    ThePlayer:PushEvent("OpenTestWidget")
    

即可开启演示界面




同时附带了右摇杆施法控制器示例，使用测试代码 注册函数并运行示例。
如果是带洞穴的存档，需要先在服务端运行，再在客户端运行

测试临时代码则使用 

    dofile(resolvefilepath("test_fn/test.lua"))

运行这个lua里面的内容。



 
This is a mod example and corresponding reference material.

Used to solve the handle virtual control mouse problem to achieve various fancy custom HUD interface click interaction.

Console input  

    ThePlayer:PushEvent(“OpenTestWidget”)

    
to open the demo widget.




It also comes with a right stick casting controller example, use the test code to register the function and run the example.

If it is an archive with caves, you need to run it on the server side before running it on the client side

To test the temporary code, use the 

    dofile(resolvefilepath(“test_fn/test.lua”))
    
Run the contents of this lua.