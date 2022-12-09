SRC_DIR := src
OUT_DIR := out

run: build
	java -cp $(OUT_DIR) Day9

build: $(OUT_DIR)/Day9.class

clean:
	rm -r $(OUT_DIR)

.PHONY: run build clean

$(OUT_DIR)/Day9.class: $(SRC_DIR)/Day9.java
	javac -d $(OUT_DIR) $(SRC_DIR)/Day9.java
