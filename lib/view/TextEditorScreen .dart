import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor_app/models/TextItem.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({Key? key}) : super(key: key);

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class EditorState {
  final List<TextItem> textItems;

  EditorState(this.textItems);

  EditorState copyWith() {
    return EditorState(textItems.map((item) => item.copyWith()).toList());
  }
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  List<TextItem> textItems = [];
  int? selectedTextIndex;
  List<EditorState> undoStack = [];
  List<EditorState> redoStack = [];

  String selectedFont = 'Roboto';
  final List<String> fonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Oswald',
    'Raleway',
    'Poppins',
    'Merriweather',
    'Playfair Display',
    'Dancing Script',
    'Pacifico',
    'Satisfy',
  ];

  void saveState() {
    undoStack.add(
      EditorState(textItems.map((item) => item.copyWith()).toList()),
    );
    redoStack.clear();
    if (undoStack.length > 50) undoStack.removeAt(0);
  }

  void undo() {
    if (undoStack.isEmpty) return;
    setState(() {
      redoStack.add(
        EditorState(textItems.map((item) => item.copyWith()).toList()),
      );
      final previousState = undoStack.removeLast();
      textItems = previousState.textItems
          .map((item) => item.copyWith())
          .toList();
      selectedTextIndex = null;
    });
  }

  void redo() {
    if (redoStack.isEmpty) return;
    setState(() {
      undoStack.add(
        EditorState(textItems.map((item) => item.copyWith()).toList()),
      );
      final nextState = redoStack.removeLast();
      textItems = nextState.textItems.map((item) => item.copyWith()).toList();
      selectedTextIndex = null;
    });
  }

  void addText() {
    saveState();
    setState(() {
      textItems.add(
        TextItem(
          text: 'New Text',
          position: Offset(
            MediaQuery.of(context).size.width / 2 - 50,
            MediaQuery.of(context).size.height / 3,
          ),
          fontFamily: selectedFont,
        ),
      );
      selectedTextIndex = textItems.length - 1;
    });
  }

  void updateTextPosition(int index, Offset delta) {
    setState(() {
      textItems[index].position += delta;
    });
  }

  void increaseFontSize() {
    if (selectedTextIndex == null) return;
    saveState();
    setState(() => textItems[selectedTextIndex!].fontSize += 2);
  }

  void decreaseFontSize() {
    if (selectedTextIndex == null) return;
    if (textItems[selectedTextIndex!].fontSize <= 10) return;
    saveState();
    setState(() => textItems[selectedTextIndex!].fontSize -= 2);
  }

  void toggleBold() {
    if (selectedTextIndex == null) return;
    saveState();
    setState(() {
      textItems[selectedTextIndex!].fontWeight =
          textItems[selectedTextIndex!].fontWeight == FontWeight.bold
          ? FontWeight.normal
          : FontWeight.bold;
    });
  }

  void toggleItalic() {
    if (selectedTextIndex == null) return;
    saveState();
    setState(
      () => textItems[selectedTextIndex!].isItalic =
          !textItems[selectedTextIndex!].isItalic,
    );
  }

  void toggleUnderline() {
    if (selectedTextIndex == null) return;
    saveState();
    setState(
      () => textItems[selectedTextIndex!].isUnderline =
          !textItems[selectedTextIndex!].isUnderline,
    );
  }

  void changeFontFamily(String? newFont) {
    if (newFont == null || selectedTextIndex == null) return;
    saveState();
    setState(() {
      selectedFont = newFont;
      textItems[selectedTextIndex!].fontFamily = newFont;
    });
  }

  TextStyle getGoogleFontStyle(String fontName, TextItem item) {
    TextStyle baseStyle = TextStyle(
      fontSize: item.fontSize,
      fontWeight: item.fontWeight,
      fontStyle: item.isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: item.isUnderline
          ? TextDecoration.underline
          : TextDecoration.none,
      color: Colors.black87,
    );

    switch (fontName) {
      case 'Roboto':
        return GoogleFonts.roboto(textStyle: baseStyle);
      case 'Open Sans':
        return GoogleFonts.openSans(textStyle: baseStyle);
      case 'Lato':
        return GoogleFonts.lato(textStyle: baseStyle);
      case 'Montserrat':
        return GoogleFonts.montserrat(textStyle: baseStyle);
      case 'Oswald':
        return GoogleFonts.oswald(textStyle: baseStyle);
      case 'Raleway':
        return GoogleFonts.raleway(textStyle: baseStyle);
      case 'Poppins':
        return GoogleFonts.poppins(textStyle: baseStyle);
      case 'Merriweather':
        return GoogleFonts.merriweather(textStyle: baseStyle);
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay(textStyle: baseStyle);
      case 'Dancing Script':
        return GoogleFonts.dancingScript(textStyle: baseStyle);
      case 'Pacifico':
        return GoogleFonts.pacifico(textStyle: baseStyle);
      case 'Satisfy':
        return GoogleFonts.satisfy(textStyle: baseStyle);
      default:
        return GoogleFonts.roboto(textStyle: baseStyle);
    }
  }

  void editText(int index) {
    final controller = TextEditingController(text: textItems[index].text);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Edit Text',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Input Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          maxLines: 3,
                          style: GoogleFonts.poppins(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter your text...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade500,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF6C63FF,
                              ), // Modern purple accent
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () {
                              saveState();
                              setState(
                                () => textItems[index].text = controller.text
                                    .trim(),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top toolbar - Undo/Redo
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: undoStack.isEmpty ? null : undo,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: undoStack.isEmpty
                          ? Colors.grey[300]
                          : Colors.blue,
                      elevation: 4,
                    ),
                    child: const Icon(
                      Icons.undo,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: redoStack.isEmpty ? null : redo,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: redoStack.isEmpty
                          ? Colors.grey[300]
                          : Colors.blue,
                      elevation: 4,
                    ),
                    child: const Icon(
                      Icons.redo,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),

            // Canvas area
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedTextIndex = null),
                child: Container(
                  color: Colors.grey[100],
                  child: Stack(
                    children: [
                      for (int i = 0; i < textItems.length; i++)
                        Positioned(
                          left: textItems[i].position.dx,
                          top: textItems[i].position.dy,
                          child: GestureDetector(
                            onPanUpdate: (details) =>
                                updateTextPosition(i, details.delta),
                            onPanEnd: (details) => saveState(),
                            onTap: () => setState(() => selectedTextIndex = i),
                            onDoubleTap: () => editText(i),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: selectedTextIndex == i
                                    ? Border.all(
                                        color: Colors.blueAccent,
                                        width: 2,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                                color: selectedTextIndex == i
                                    ? Colors.blue.withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Text(
                                textItems[i].text,
                                style: getGoogleFontStyle(
                                  textItems[i].fontFamily,
                                  textItems[i],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom toolbar - Split into two rows for better spacing
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // First row: Font dropdown and font size controls
                  Row(
                    children: [
                      // Font Dropdown - Takes available space
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedFont,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down, size: 20),
                              items: fonts.map((String font) {
                                return DropdownMenuItem<String>(
                                  value: font,
                                  child: Text(
                                    font,
                                    style: GoogleFonts.getFont(
                                      font,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              }).toList(),

                              onChanged: changeFontFamily,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Font size controls
                      IconButton(
                        onPressed: selectedTextIndex != null
                            ? decreaseFontSize
                            : null,
                        icon: const Icon(Icons.remove, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectedTextIndex != null
                              ? textItems[selectedTextIndex!].fontSize
                                    .toInt()
                                    .toString()
                              : '10',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: selectedTextIndex != null
                            ? increaseFontSize
                            : null,
                        icon: const Icon(Icons.add, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Second row: Formatting buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedTextIndex != null
                              ? toggleBold
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                selectedTextIndex != null &&
                                    textItems[selectedTextIndex!].fontWeight ==
                                        FontWeight.bold
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                          child: const Icon(Icons.format_bold, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedTextIndex != null
                              ? toggleItalic
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                selectedTextIndex != null &&
                                    textItems[selectedTextIndex!].isItalic
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                          child: const Icon(Icons.format_italic, size: 20),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedTextIndex != null
                              ? toggleUnderline
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                selectedTextIndex != null &&
                                    textItems[selectedTextIndex!].isUnderline
                                ? Colors.blue
                                : Colors.grey[300],
                          ),
                          child: const Icon(Icons.format_underline, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Add Text Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: addText,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Text'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
