package com.sierotech.mproject.common.utils;


import java.util.List;

public abstract interface INode
{
  public abstract String getValue();

  public abstract String getAttrValue(String paramString);

  public abstract INode getSubNode(String paramString);

  public abstract List<INode> getSubNodes(String paramString);
}