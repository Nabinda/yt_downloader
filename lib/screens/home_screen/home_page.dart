import 'package:auto_size_text/auto_size_text.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/provider/api_content.dart';
import 'widgets/default_display.dart';
import 'widgets/search_results.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  bool isSearch = false;
  bool isValid = true;
  bool showSearch = false;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    _textEditingController.clear();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
  }

  void search(String query) {
    Provider.of<APIContent>(context,listen: false).clearSearch();
    Provider.of<APIContent>(context,listen: false).clearSimilarSearch();
    setState(() {
      isSearch = true;
    });
    Provider.of<APIContent>(context, listen: false)
        .searchVideo(query);
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void toggleSearchMenu() {
    setState(() {
      showSearch = !showSearch;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            showSearch
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.75,
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _textEditingController,
                          maxLines: 1,
                          onChanged: (value) {
                            setState(() {
                              if (_textEditingController.text.trim() == '') {
                                isSearch = false;
                              } else {
                                isValid = true;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorText: isValid ? null : 'Field Can\'t Be Empty',
                            focusColor: Colors.red,
                          ),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w400),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (text) {
                            if (_textEditingController.text.trim() == '') {
                              setState(() {
                                isValid = false;
                              });
                              FocusScope.of(context).requestFocus(_focusNode);
                            } else {
                              FocusScope.of(context).unfocus();
                              search(_textEditingController.text);
                            }
                          },
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (_textEditingController.text.trim() == '') {
                              setState(() {
                                isValid = false;
                              });
                              FocusScope.of(context).requestFocus(_focusNode);
                            } else {
                              FocusScope.of(context).unfocus();
                              search(_textEditingController.text);
                            }
                          },
                          icon: const Icon(
                            EvaIcons.search,
                            color: Colors.red,
                            size: 28,
                          ))
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AutoSizeText(
                        'Youtube Downloader',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                        maxLines: 1,
                      ),
                      IconButton(
                          onPressed: toggleSearchMenu,
                          icon: const Icon(
                            EvaIcons.searchOutline,
                            color: Colors.black,
                            size: 28,
                          ))
                    ],
                  ),
            isSearch
                ? const SearchResults()
                : InkWell(
                    onTap: () {
                      if (showSearch) {
                        toggleSearchMenu();
                        setState(() {
                          isValid = true;
                        });
                      } else {
                        null;
                      }
                    },
                    child: const DefaultDisplay()),
          ]),
        ),
      ),
    ));
  }
}
