# excel导出报错：The supplied data appears to be in the Office 2007+ XML.

```
POIFSFileSystem excelFile = new POIFSFileSystem(new FileInputStream("E:/sellOrder.xls"));
HSSFWorkbook wb = new HSSFWorkbook(excelFile);
```

用以上语句导出excel的时候报错：
> 信息: Request processing failed; nested exception is org.apache.poi.poifs.filesystem.OfficeXmlFileException: The supplied data appears to be in the Office 2007+ XML. POI only supports OLE2 Office documents

原因是：
> - HSSFWorkbook:是操作Excel2003以前（包括2003）的版本，扩展名是.xls 
> - XSSFWorkbook:是操作Excel2007的版本，扩展名是.xlsx