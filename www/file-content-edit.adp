<master>
<if @webdav_url@ not nil>
      <p>This file can be accessed via WebDAV at @webdav_url@</p>
</if>

<include src="../lib/content-edit" file_id="@file_id@" return_url="@return_url;noquote@" man_id="@man_id@" res_id="@res_id@">
