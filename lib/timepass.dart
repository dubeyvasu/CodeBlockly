import 'package:flutter/material.dart';

class Timepass extends StatelessWidget {
  const Timepass({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> names = [
  "Vasudev Dubey",
  "Anjali Sharma",
  "Rohit Gupta",
  "Sneha Mehta",
  "Arjun Verma",
  "Priya Nair",
  "Amit Khanna",
  "Riya Kapoor",
  "Rajesh Patel",
  "Nikita Rao",
  "Siddharth Iyer",
  "Pooja Choudhary",
  "Karan Singh",
  "Meera Joshi",
];




  final List<String> imageUrls = [
    "https://picsum.photos/200/300?random=1",
    "https://picsum.photos/200/300?random=2",
    "https://picsum.photos/200/300?random=3",
    "https://picsum.photos/200/300?random=4",
    "https://picsum.photos/200/300?random=5",
    "https://picsum.photos/200/300?random=6",
    "https://picsum.photos/200/300?random=7",
    "https://picsum.photos/200/300?random=8",
    "https://picsum.photos/200/300?random=9",
    "https://picsum.photos/200/300?random=10",
    "https://picsum.photos/200/300?random=11",
    "https://picsum.photos/200/300?random=12",
    "https://picsum.photos/200/300?random=13",
    "https://picsum.photos/200/300?random=14",
  ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("WhatsApp",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold,fontSize: 35)),
                SizedBox(width: 10,),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(onPressed: (){}, icon:Icon(Icons.qr_code)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(onPressed: (){}, icon:Icon(Icons.camera_alt_outlined)),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(onPressed: (){}, icon:Icon(Icons.more_vert)),
                )
                
              ],
            ),
            SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                labelText: "Ask Meta AI or Search",
          fillColor:Colors.grey,
          prefixIcon: Icon(Icons.circle_outlined,color: Colors.red,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20)
          )
              ),
            ),
            SizedBox(height: 25,),
            Flexible(
              child: ListView.builder(
               itemCount: 14,
              shrinkWrap: false,
              itemBuilder:(context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                       backgroundImage: NetworkImage(imageUrls[index]),
                      ),
              
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(names[index],style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("hii i am vasudev dubey",style: TextStyle(color: Colors.grey,fontSize: 10,),),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },),
            )
          ],
        ),
      ),
      bottomNavigationBar: 
      BottomNavigationBar(
        backgroundColor: Colors.white,
        items:<BottomNavigationBarItem>[
           BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Icon(Icons.chat_outlined,color: Colors.black,),
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update,color: Colors.black),
          
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2_outlined,color: Colors.black),
            label: 'Groups',
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_outlined,color: Colors.black),
            label: 'Calls',
          ),
        ]
        ),
    );
  }
}