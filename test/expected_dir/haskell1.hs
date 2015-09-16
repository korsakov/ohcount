haskell	comment	{-|
haskell	comment	  This module contains some functions that are useful in several places in the
haskell	comment	  program and don't belong to one specific other module.
haskell	comment	-}
haskell	code	module Gnutella.Misc where
haskell	blank	
haskell	code	import Data.ByteString(ByteString)
haskell	code	import qualified Data.ByteString as BS
haskell	code	import Data.Bits
haskell	code	import Data.Word
haskell	code	import Text.Read
haskell	code	import Data.Char(isNumber)
haskell	code	import Data.List(intersperse)
haskell	code	import Network
haskell	code	import Network.BSD(getHostByName, HostEntry(..))
haskell	code	import Network.Socket(HostAddress(..))
haskell	code	import Debug.Trace
haskell	blank	
haskell	comment	{-|
haskell	comment	  Maakt van vier bytes een Word32. Gaat ervan uit dat die vier bytes little-endian achter elkaar
haskell	comment	  staan. Als de gegeven string korter is dan 4 bytes, termineert de functie. Als de string langer
haskell	comment	  is, worden alle bytes voorbij de vierde genegeerd.
haskell	comment	-}
haskell	code	composeWord32 :: ByteString -> Word32
haskell	code	composeWord32 s = shiftL byte4 24 + shiftL byte3 16 + shiftL byte2 8 + byte1
haskell	code	  where byte1, byte2, byte3, byte4 :: Word32
haskell	code	        [byte1, byte2, byte3, byte4] = map fromIntegral $ BS.unpack (BS.take 4 s)
haskell	blank	
haskell	comment	{-| 
haskell	comment	  Turns a Word32 into a tuple of Word8s. The tuple is little-endian: the least
haskell	comment	  significant octet comes first.
haskell	comment	-}
haskell	code	word32ToWord8s :: Word32 -> (Word8, Word8, Word8, Word8)
haskell	code	word32ToWord8s w = (fromIntegral (w .&. 0x000000ff)
haskell	code	                   ,fromIntegral (shiftR w 8 .&. 0x000000ff)
haskell	code	                   ,fromIntegral (shiftR w 16 .&. 0x000000ff)
haskell	code	                   ,fromIntegral (shiftR w 24 .&. 0x000000ff)
haskell	code	                   )
haskell	blank	
haskell	comment	{-|
haskell	comment	  Parses a host specification in the "name:12345"-style notation into a hostname
haskell	comment	  and a port number.
haskell	blank	
haskell	comment	  As a rather special feature, it returns 6346 as the port number when there is
haskell	comment	  no port specified. When there is a port specified, but it is unparseable, it
haskell	comment	  returns Nothing.
haskell	comment	-}
haskell	code	parseHostnameWithPort :: String -> IO (Maybe ((Word8, Word8, Word8, Word8)
haskell	code	                                             ,PortNumber))
haskell	code	parseHostnameWithPort str = do maybeHostName <- stringToIP hostNameStr
haskell	code	                               return $ (do portNum <- maybePortNum
haskell	code	                                            hostName <- maybeHostName
haskell	code	                                            return (hostName, portNum)
haskell	code	                                        )
haskell	code	  where hostNameStr = takeWhile (/=':') str
haskell	code	        maybePortNum  = case tail (dropWhile (/=':') str) of
haskell	code	                          [] -> Just $ 6346
haskell	code	                          s  -> case reads s of
haskell	code	                                  []     -> Nothing
haskell	code	                                  (x:xs) -> Just $ fromIntegral $ fst x
haskell	blank	
haskell	comment	{-|
haskell	comment	  Translates a string, representing an IP address, to a list of bytes.
haskell	comment	  Returns Nothing when the string does not represent an IP address in xxx.xxx.xxx.xxx format
haskell	comment	-}
haskell	code	ipStringToBytes :: String -> Maybe (Word8, Word8, Word8, Word8)
haskell	comment	-- Again, hugs won't let us use regexes where they would be damn convenient
haskell	code	ipStringToBytes s =
haskell	code	    let ipBytesStrings = splitAtDots s
haskell	code	    in if all (all isNumber) ipBytesStrings
haskell	code	         then let bytesList = map (fst . head . reads) ipBytesStrings
haskell	code	              in Just (bytesList!!0
haskell	code	                      ,bytesList!!1
haskell	code	                      ,bytesList!!2
haskell	code	                      ,bytesList!!3
haskell	code	                      )
haskell	code	         else Nothing
haskell	code	  where splitAtDots s = foldr (\c (n:nums) -> if c == '.'
haskell	code	                                              then [] : n : nums
haskell	code	                                              else (c:n) : nums
haskell	code	                              ) [[]] s
haskell	blank	
haskell	comment	{-|
haskell	comment	  Translates a list of bytes representing an IP address (big endian) to a string
haskell	comment	  in the xxx.xxx.xxx.xxx format.
haskell	comment	-}
haskell	code	ipBytesToString :: (Word8, Word8, Word8, Word8) -> String
haskell	code	ipBytesToString (b1, b2, b3, b4) = 
haskell	code	    concat $ intersperse "." $ map show [b1, b2, b3, b4]
haskell	blank	
haskell	comment	{-| 
haskell	comment	  Takes a String that's either an IP address or a hostname, and returns you the
haskell	comment	  IP address as a list of 4 bytes (in big-endian byte order). It returns Nothing
haskell	comment	  if there is no parse for the string as IP address and the hostname can't be
haskell	comment	  found.
haskell	comment	-}
haskell	code	stringToIP :: String -> IO (Maybe (Word8, Word8, Word8, Word8))
haskell	code	stringToIP hostName = case ipStringToBytes hostName of
haskell	code	                        Just a  -> return (Just a)
haskell	code	                        Nothing -> do hostent <- getHostByName hostName
haskell	code	                                      let ipWord32 = head (hostAddresses hostent)
haskell	code	                                          ipWord8s = word32ToWord8s ipWord32
haskell	code	                                      return (Just ipWord8s)
haskell	blank	
haskell	comment	-- used in reading the hostcache
haskell	code	instance Read PortNumber where
haskell	code	    readsPrec i = map (\(a, b) -> (fromIntegral a, b)) . (readsPrec i :: ReadS Word16)
haskell	blank	
