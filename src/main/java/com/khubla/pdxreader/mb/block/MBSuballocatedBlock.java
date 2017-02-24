package com.khubla.pdxreader.mb.block;

import java.io.IOException;

import com.google.common.io.LittleEndianDataInputStream;
import com.khubla.pdxreader.api.PDXReaderException;
import com.khubla.pdxreader.mb.MBTableBlock;

public class MBSuballocatedBlock extends MBTableBlock {
   public MBSuballocatedBlock() {
      super(MBTableBlock.RecordType.suballocated);
   }

   @Override
   public void read(LittleEndianDataInputStream littleEndianDataInputStream) throws PDXReaderException {
      try {
         final int blockType = littleEndianDataInputStream.readByte();
         if (blockType != super.recordType.getValue()) {
            throw new PDXReaderException("Block type mismatch");
         }
         final int sizeofBlock = littleEndianDataInputStream.readUnsignedShort();
         if ((sizeofBlock * BLOCK_SIZE_MULTIPLIER) != super.sizeofBlock) {
            throw new PDXReaderException("Block type mismatch");
         }
      } catch (final IOException e) {
         throw new PDXReaderException("Exception reading inputStream", e);
      }
   }
}
