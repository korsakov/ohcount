{-|
  This module contains some functions that are useful in several places in the
  program and don't belong to one specific other module.
-}
module Gnutella.Misc where

import Data.ByteString(ByteString)
import qualified Data.ByteString as BS
import Data.Bits
import Data.Word
import Text.Read
import Data.Char(isNumber)
import Data.List(intersperse)
import Network
import Network.BSD(getHostByName, HostEntry(..))
import Network.Socket(HostAddress(..))
import Debug.Trace

{-|
  Maakt van vier bytes een Word32. Gaat ervan uit dat die vier bytes little-endian achter elkaar
  staan. Als de gegeven string korter is dan 4 bytes, termineert de functie. Als de string langer
  is, worden alle bytes voorbij de vierde genegeerd.
-}
composeWord32 :: ByteString -> Word32
composeWord32 s = shiftL byte4 24 + shiftL byte3 16 + shiftL byte2 8 + byte1
  where byte1, byte2, byte3, byte4 :: Word32
        [byte1, byte2, byte3, byte4] = map fromIntegral $ BS.unpack (BS.take 4 s)

{-| 
  Turns a Word32 into a tuple of Word8s. The tuple is little-endian: the least
  significant octet comes first.
-}
word32ToWord8s :: Word32 -> (Word8, Word8, Word8, Word8)
word32ToWord8s w = (fromIntegral (w .&. 0x000000ff)
                   ,fromIntegral (shiftR w 8 .&. 0x000000ff)
                   ,fromIntegral (shiftR w 16 .&. 0x000000ff)
                   ,fromIntegral (shiftR w 24 .&. 0x000000ff)
                   )

{-|
  Parses a host specification in the "name:12345"-style notation into a hostname
  and a port number.

  As a rather special feature, it returns 6346 as the port number when there is
  no port specified. When there is a port specified, but it is unparseable, it
  returns Nothing.
-}
parseHostnameWithPort :: String -> IO (Maybe ((Word8, Word8, Word8, Word8)
                                             ,PortNumber))
parseHostnameWithPort str = do maybeHostName <- stringToIP hostNameStr
                               return $ (do portNum <- maybePortNum
                                            hostName <- maybeHostName
                                            return (hostName, portNum)
                                        )
  where hostNameStr = takeWhile (/=':') str
        maybePortNum  = case tail (dropWhile (/=':') str) of
                          [] -> Just $ 6346
                          s  -> case reads s of
                                  []     -> Nothing
                                  (x:xs) -> Just $ fromIntegral $ fst x

{-|
  Translates a string, representing an IP address, to a list of bytes.
  Returns Nothing when the string does not represent an IP address in xxx.xxx.xxx.xxx format
-}
ipStringToBytes :: String -> Maybe (Word8, Word8, Word8, Word8)
-- Again, hugs won't let us use regexes where they would be damn convenient
ipStringToBytes s =
    let ipBytesStrings = splitAtDots s
    in if all (all isNumber) ipBytesStrings
         then let bytesList = map (fst . head . reads) ipBytesStrings
              in Just (bytesList!!0
                      ,bytesList!!1
                      ,bytesList!!2
                      ,bytesList!!3
                      )
         else Nothing
  where splitAtDots s = foldr (\c (n:nums) -> if c == '.'
                                              then [] : n : nums
                                              else (c:n) : nums
                              ) [[]] s

{-|
  Translates a list of bytes representing an IP address (big endian) to a string
  in the xxx.xxx.xxx.xxx format.
-}
ipBytesToString :: (Word8, Word8, Word8, Word8) -> String
ipBytesToString (b1, b2, b3, b4) = 
    concat $ intersperse "." $ map show [b1, b2, b3, b4]

{-| 
  Takes a String that's either an IP address or a hostname, and returns you the
  IP address as a list of 4 bytes (in big-endian byte order). It returns Nothing
  if there is no parse for the string as IP address and the hostname can't be
  found.
-}
stringToIP :: String -> IO (Maybe (Word8, Word8, Word8, Word8))
stringToIP hostName = case ipStringToBytes hostName of
                        Just a  -> return (Just a)
                        Nothing -> do hostent <- getHostByName hostName
                                      let ipWord32 = head (hostAddresses hostent)
                                          ipWord8s = word32ToWord8s ipWord32
                                      return (Just ipWord8s)

-- used in reading the hostcache
instance Read PortNumber where
    readsPrec i = map (\(a, b) -> (fromIntegral a, b)) . (readsPrec i :: ReadS Word16)

