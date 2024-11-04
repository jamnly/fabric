#!/bin/bash

# 设置通道名称
CHANNEL_NAME="mychannel"

# 设置开始和结束区块编号
START_BLOCK=7753
END_BLOCK=7944

# 创建一个用于存储区块和JSON文件的文件夹，并带有时间戳确保唯一性
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="./output_blocks_$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

# 生成唯一的汇总文件名
RESULT_FILE="./block_analysis_results_$TIMESTAMP.txt"

# 初始化汇总文件并写入标题
echo "区块 $START_BLOCK 到 $END_BLOCK 的区块大小分析" > $RESULT_FILE
echo "生成时间: $TIMESTAMP" >> $RESULT_FILE
echo "----------------------------------------------" >> $RESULT_FILE

# 初始化总计变量
TOTAL_BLOCK_COUNT=0
TOTAL_DATA_COUNT=0
TOTAL_BLOCK_SIZE_KB=0
TOTAL_BLOCK_SIZE_byte=0
MAX_DATA_COUNT=0  # 最大区块交易数

# 循环获取每个区块并进行解码和分析
for ((i=START_BLOCK; i<=END_BLOCK; i++))
do
    echo "正在获取区块 $i..."

    # 获取区块并保存到指定的输出文件夹
    peer channel fetch $i "$OUTPUT_DIR/blockfile_$i.block" -c $CHANNEL_NAME

    if [ $? -ne 0 ]; then
        echo "获取区块 $i 时出错，跳过..." | tee -a $RESULT_FILE
        continue
    fi

    echo "正在解码区块 $i 到 block_$i.json..."

    # 解码区块到 JSON 文件，并存储在指定文件夹中
    configtxlator proto_decode --input "$OUTPUT_DIR/blockfile_$i.block" --type common.Block --output "$OUTPUT_DIR/block_$i.json"

    if [ $? -ne 0 ]; then
        echo "解码区块 $i 时出错，跳过..." | tee -a $RESULT_FILE
        continue
    fi

    # 计算区块大小（以 KB 和字节为单位）
    BLOCK_SIZE_KB=$(du -k "$OUTPUT_DIR/blockfile_$i.block" | cut -f1)
    BLOCK_SIZE_byte=$((BLOCK_SIZE_KB * 1024 ))  # KB 转换为字节

    # 获取区块中的交易数量
    DATA_COUNT=$(jq '.data.data | length' "$OUTPUT_DIR/block_$i.json")
    
    # 计算每个数据的平均大小（以 KB 和字节表示）
    if [ "$DATA_COUNT" -gt 0 ]; then
        AVG_SIZE_KB=$(echo "scale=2; $BLOCK_SIZE_KB / $DATA_COUNT" | bc)
        AVG_SIZE_BITS=$((BLOCK_SIZE_byte / DATA_COUNT))
    else
        AVG_SIZE_KB="N/A"
        AVG_SIZE_BITS="N/A"
    fi

    # 统计总的区块数、总的交易数和总的区块大小
    TOTAL_BLOCK_COUNT=$((TOTAL_BLOCK_COUNT+1))
    TOTAL_DATA_COUNT=$((TOTAL_DATA_COUNT+DATA_COUNT))
    TOTAL_BLOCK_SIZE_KB=$((TOTAL_BLOCK_SIZE_KB+BLOCK_SIZE_KB))
    TOTAL_BLOCK_SIZE_byte=$((TOTAL_BLOCK_SIZE_byte+BLOCK_SIZE_byte))

    # 更新最大交易数
    if [ "$DATA_COUNT" -gt "$MAX_DATA_COUNT" ]; then
        MAX_DATA_COUNT=$DATA_COUNT
    fi

    # 追加结果到汇总文件
    echo "区块 $i: 大小 (KB) = $BLOCK_SIZE_KB, 大小 (字节) = $BLOCK_SIZE_byte, 数据数 = $DATA_COUNT, 平均每组数据大小 (KB) = $AVG_SIZE_KB, 平均每组数据大小 (字节) = $AVG_SIZE_BITS" | tee -a $RESULT_FILE
done

# 计算 TPS （总交易数 / 总区块数）
if [ "$TOTAL_BLOCK_COUNT" -gt 0 ]; then
    TPS=$(echo "scale=2; $TOTAL_DATA_COUNT / $TOTAL_BLOCK_COUNT" | bc)
else
    TPS="N/A"
fi

# 计算平均数据数
if [ "$TOTAL_BLOCK_COUNT" -gt 0 ]; then
    AVG_DATA_COUNT=$(echo "scale=2; $TOTAL_DATA_COUNT / $TOTAL_BLOCK_COUNT" | bc)
else
    AVG_DATA_COUNT="N/A"
fi

# 追加总计结果到汇总文件
echo "区块大小分析结果" >> $RESULT_FILE
echo "----------------------------------------------" >> $RESULT_FILE
echo "总区块数: $TOTAL_BLOCK_COUNT" | tee -a $RESULT_FILE
echo "总数据数: $TOTAL_DATA_COUNT" | tee -a $RESULT_FILE
echo "平均数据数: $AVG_DATA_COUNT" | tee -a $RESULT_FILE
echo "最大区块交易数: $MAX_DATA_COUNT" | tee -a $RESULT_FILE
echo "总区块大小 (KB): $TOTAL_BLOCK_SIZE_KB" | tee -a $RESULT_FILE
echo "总区块大小 (字节): $TOTAL_BLOCK_SIZE_byte" | tee -a $RESULT_FILE
echo "平均 TPS (每个区块的交易数量): $TPS" | tee -a $RESULT_FILE

# 打印结果文件路径
echo "区块分析完成。结果已保存到 $RESULT_FILE"

